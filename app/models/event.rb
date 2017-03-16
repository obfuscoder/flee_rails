class Event < ActiveRecord::Base
  enum kind: [:commissioned, :direct]
  has_many :reservations, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :handover_periods, -> { where(kind: :handover).order(:min) }, class_name: 'TimePeriod', dependent: :destroy
  has_many :shopping_periods, -> { where(kind: :shopping).order(:min) }, class_name: 'TimePeriod', dependent: :destroy
  has_many :pickup_periods, -> { where(kind: :pickup).order(:min) }, class_name: 'TimePeriod', dependent: :destroy

  accepts_nested_attributes_for :shopping_periods, :handover_periods, :pickup_periods,
                                allow_destroy: true, reject_if: :all_blank

  validates_presence_of :name, :max_sellers, :seller_fee
  validates_presence_of :max_items_per_reservation, :price_precision, :commission_rate, if: -> { kind == :commissioned }
  validates :seller_fee, numericality: { greater_than_or_equal_to: 0.0, less_than: 50 }
  validates :max_sellers, numericality: { greater_than: 0, only_integer: true }

  with_options if: :commissioned? do |event|
    event.validates :price_precision, numericality: { greater_than_or_equal_to: 0.1, less_than_or_equal_to: 1 }
    event.validates :commission_rate, numericality: { greater_than_or_equal_to: 0.0, less_than: 1 }
    event.validates :max_items_per_reservation, numericality: { greater_than: 0, only_integer: true }
  end

  scope :reservation_started, -> { where { reservation_start <= Time.now } }
  scope :reservation_not_yet_ended, -> { where { reservation_end >= Time.now } }
  scope :within_reservation_time, -> { reservation_started.reservation_not_yet_ended }
  scope :without_reservation_for, ->(seller) { where { id << seller.reservations.map(&:event_id) } }
  scope :current_or_upcoming, -> { joins { shopping_periods }.where { shopping_periods.max >= Time.now } }
  scope :with_sent, ->(category) { joins { messages }.where { messages.category == category.to_s } }
  scope :reservable, -> { within_reservation_time.with_available_reservations }

  def self.with_available_reservations
    joins { reservations.outer }.group(:id).having { count(reservations.id) < max_sellers }
  end

  def reservable_by?(seller)
    return reservations.where(seller: seller).empty? if max_reservations_per_seller.nil?
    reservations.where(seller: seller).count < max_reservations_per_seller
  end

  def reviewed_by?(seller)
    reservations.any? { |reservation| reservation.seller == seller && reservation.review.present? }
  end

  def reservations_left
    [max_sellers - reservations.count, 0].max
  end

  def seller_fee=(number)
    number.tr!(',', '.') if number.is_a? String
    self[:seller_fee] = number.try(:to_d)
  end

  def to_s
    name || super
  end

  def reviews
    reservations.map(&:review).compact
  end

  def past?
    shopping_periods.last.max.past?
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
    reservations.joins(:items).merge(Item.sold).sum(:price)
  end

  def sold_item_percentage
    return 0 if item_count.zero?
    sold_item_count * 100 / item_count
  end

  def top_sellers
    result = reservations.joins(:items).merge(Item.sold).group { reservations.number }.select do
      [reservations.number, count(items.id).as(count)]
    end
    result.order { count(items.id).desc }.map { |e| [e.number, e.count] }
  end

  def items_per_category
    reservations.joins { items }.joins { items.category }.group { items.category.name }
                .select { [items.category.name, count(items.id).as(count)] }
                .order { count(items.id).desc }.map { |e| [e.name, e.count] }
  end

  def sold_items_per_category
    reservations.joins { items }.merge(Item.sold).joins { items.category }.group { items.category.name }
                .select { [items.category.name, count(items.id).as(count)] }
                .order { count(items.id).desc }.map { |e| [e.name, e.count] }
  end

  def sellers_per_zip_code
    reservations.joins { seller }.group { seller.zip_code }.select { [seller.zip_code, count(seller.id).as(count)] }
  end

  def sellers_per_city
    sellers_per_zip_code.map { |e| [Rails.application.config.zip_codes[e.zip_code] || e.zip_code, e.count] }
                        .each_with_object({}) { |(z, c), h| h[z] = (h[z] || 0) + c }
                        .to_a.sort { |a, b| b.second <=> a.second }
  end

  before_save do
    unless token
      self.token = loop do
        random_token = SecureRandom.urlsafe_base64(8, false)
        break random_token unless self.class.exists?(token: random_token)
      end
    end
  end
end
