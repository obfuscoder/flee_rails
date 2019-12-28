class Event < ApplicationRecord
  enum kind: { commissioned: 0, direct: 1 }
  belongs_to :client
  has_one :bill, dependent: :destroy
  has_many :reservations, -> { order :id }, inverse_of: :event
  has_many :reviews, through: :reservations
  has_many :items, -> { order 'reservations.number' }, through: :reservations
  has_many :notifications, -> { order :id }, inverse_of: :event
  has_many :messages, dependent: :delete_all
  has_many :support_types, dependent: :delete_all
  has_many :suspensions, dependent: :delete_all
  has_many :rentals, dependent: :delete_all
  has_many :sold_stock_items, dependent: :delete_all
  has_many :stock_items, through: :sold_stock_items
  has_many :handover_periods, -> { where(kind: :handover).order(:min) },
           class_name: 'TimePeriod',
           dependent: :delete_all,
           inverse_of: :event
  has_many :shopping_periods, -> { where(kind: :shopping).order(:min) },
           class_name: 'TimePeriod',
           dependent: :delete_all,
           inverse_of: :event
  has_many :pickup_periods, -> { where(kind: :pickup).order(:min) },
           class_name: 'TimePeriod',
           dependent: :delete_all,
           inverse_of: :event
  has_many :transactions, dependent: :destroy

  accepts_nested_attributes_for :shopping_periods, :handover_periods, :pickup_periods,
                                allow_destroy: true, reject_if: :all_blank

  validates :client, :name, :max_reservations, :reservation_fee, :number, presence: true
  validates :max_items_per_reservation, :price_precision, :commission_rate,
            presence: { if: -> { kind == :commissioned } }
  validates :reservation_fee, numericality: { greater_than_or_equal_to: 0.0, less_than: 50 }
  validates :max_reservations, numericality: { greater_than: 0, only_integer: true }
  validates :reservation_start, :reservation_end, presence: true

  with_options if: :commissioned? do
    validates :price_precision, numericality: { greater_than_or_equal_to: 0.1, less_than_or_equal_to: 1 }
    validates :commission_rate, numericality: { greater_than_or_equal_to: 0.0, less_than: 1 }
    validates :max_items_per_reservation, numericality: { greater_than: 0, only_integer: true }
  end

  validates :number, numericality: { greater_than: 0, only_integer: true }, uniqueness: { scope: :client_id }

  before_validation :create_number

  scope :reservation_started, -> { where.has { reservation_start <= Time.now } }
  scope :reservation_not_yet_ended, -> { where.has { reservation_end >= Time.now } }
  scope :within_reservation_time, -> { reservation_started.reservation_not_yet_ended }
  scope :without_reservation_for, ->(seller) { where.not(id: seller.reservations.map(&:event_id)) }
  scope :current_or_upcoming, -> { joining { shopping_periods }.where.has { shopping_periods.max >= Time.now } }
  scope :with_sent, ->(category) { joining { messages }.where.has { messages.category == category.to_s } }
  scope :reservable, -> { within_reservation_time.with_available_reservations }
  scope :past, -> { joining { shopping_periods }.where.has { shopping_periods.max < 2.days.ago } }
  scope :without_bill, -> { where.not(bill) }

  def self.in_need_of_support
    where(support_system_enabled: true).joining { support_types }.select do |event|
      event.support_types.any? { |support_type| support_type.capacity > support_type.supporters.count }
    end
  end

  def self.with_available_reservations
    joining { reservations.outer }.grouping { id }.when_having { reservations.id.count < max_reservations }
  end

  def reservable_by?(seller)
    reservations_left? && client.reservation_by_seller_allowed? &&
      can_add_to_notifications?(seller)
  end

  def notifiable_by?(seller)
    seller.client.reservation_by_seller_allowed? && can_add_to_notifications?(seller)
  end

  def reviewed_by?(seller)
    reservations.any? { |reservation| reservation.seller == seller && reservation.review.present? }
  end

  def reservations_left
    [max_reservations - reservations.count, 0].max
  end

  def reservations_left?
    reservations_left.positive?
  end

  def max_reservations_per_seller
    self[:max_reservations_per_seller] || 1
  end

  def reservation_fee=(number)
    number.tr!(',', '.') if number.is_a? String
    self[:reservation_fee] = number.try(:to_d)
  end

  def to_s
    name || super
  end

  def past?
    shopping_periods&.last&.max&.past?
  end

  def item_count
    reservations.joins(:items).count
  end

  def items_with_label_count
    reservations.joins(:items).merge(Item.with_label).count
  end

  def sold_item_count
    reservations.joins(:items).merge(Item.sold).count
  end

  def sold_item_sum
    reservations.joins(:items).merge(Item.sold).sum(:price) +
      sold_stock_items.joins(:stock_item).sum('price * amount')
  end

  def reservation_fees_sum
    reservations.all.map(&:fee).sum
  end

  def revenue
    reservation_fees_sum + sold_item_sum
  end

  def rental_fees
    rentals.all.map { |r| r.amount * r.hardware.price }.sum
  end

  def system_fees
    number == 1 ? 0 : revenue / 100
  end

  def total_fees
    rental_fees + system_fees
  end

  def sold_stock_item_count
    sold_stock_items.map(&:amount).inject(:+)
  end

  def sold_item_percentage
    return 0 if item_count.zero?

    sold_item_count * 100 / item_count
  end

  def top_sellers
    result = reservations.unscope(:order).joins(:items).merge(Item.sold).grouping { number }.selecting do
      [number, items.id.count.as('count')]
    end
    result.ordering { items.id.count.desc }.map { |e| [e.number, e.count] }
  end

  def items_per_category
    reservations.joining { items.category }.grouping { items.category.name }
                .selecting { [items.category.name, items.id.count.as('count')] }
                .ordering { items.id.count.desc }.map { |e| [e.name, e.count] }
  end

  def sold_items_per_category
    reservations.joining { items.category }.merge(Item.sold).grouping { items.category.name }
                .selecting { [items.category.name, items.id.count.as('count')] }
                .ordering { items.id.count.desc }.map { |e| [e.name, e.count] }
  end

  def sellers_per_zip_code
    reservations.joining { seller }.grouping { seller.zip_code }.selecting do
      [seller.zip_code, seller.id.count.as('count')]
    end
  end

  def sellers_per_city
    sellers_per_zip_code.map { |e| [Rails.application.config.zip_codes[e.zip_code] || e.zip_code, e.count] }
                        .each_with_object({}) { |(z, c), h| h[z] = (h[z] || 0) + c }
                        .to_a.sort { |a, b| b.second <=> a.second }
  end

  before_save do
    self.token ||= loop do
      random_token = SecureRandom.urlsafe_base64(8, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end

  private

  def can_add_to_notifications?(seller)
    !max_reservations_reached_for?(seller) &&
      !suspensions.find_by(seller: seller) &&
      !notifications.find_by(seller: seller)
  end

  def max_reservations_reached_for?(seller)
    reservations.where(seller: seller).count >= max_reservations_per_seller
  end

  def create_number
    return if client.nil? || number.present?

    current_max = client.events.maximum(:number) || 0
    self.number = current_max + 1
  end
end
