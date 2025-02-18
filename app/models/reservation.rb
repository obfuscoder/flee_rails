class Reservation < ApplicationRecord
  belongs_to :seller, -> { with_deleted }, inverse_of: :reservations
  belongs_to :event
  has_many :items, dependent: :destroy
  has_one :review, dependent: :destroy

  include Statistics

  validates :seller, :event, :number, presence: true
  validates :number, numericality: { greater_than: 0, less_than: 1000, only_integer: true },
                     uniqueness: { scope: :event_id }

  with_options on: :create do
    validate :within_reservation_period
    validate :capacity_available
    validate :max_reservations_per_seller
    validate :not_suspended
    validate :reservation_allowed_by_seller
  end

  validates :max_items, numericality: { greater_than: 0, only_integer: true }

  before_validation :create_number

  scope :for_client, ->(client) { Reservation.default_scoped.joins(:event).where.has { event.client_id.eq client.id } }

  def self.recent
    joining { event.shopping_periods }.where.has { event.shopping_periods.max >= 3.months.ago }.distinct.ordering do
      event.shopping_periods.max.desc
    end
  end

  def self.search(needle)
    needle.nil? ? all : joins(:seller).where.has { seller.sift(:full_text_search, needle) }
  end

  def to_s
    "#{event.name} - #{number}"
  end

  def increase_label_counter
    self.label_counter = label_counter.to_i + 1
    save!
    label_counter
  end

  def commission_rate
    self[:commission_rate] || event.commission_rate
  end

  def fee
    result = self[:fee] || event.reservation_fee
    event.reservation_fee_based_on_item_count? ? result * items.count : result
  end

  def max_items
    self[:max_items] || event.try(:max_items_per_reservation)
  end

  def previous?
    previous.any?
  end

  def previous
    seller.reservations.where.not(event: event)
  end

  private

  def create_number
    return if event.nil? || number.present? || seller.nil?

    self.number = default_reservation_number_usable? ? seller.default_reservation_number : next_available_number
  end

  def next_available_number
    next_available_number = (event.reservations.maximum(:number) || 0) + 1
    auto_number_start = event.client.auto_reservation_numbers_start || 1
    [next_available_number, auto_number_start].max
  end

  def default_reservation_number_usable?
    seller.default_reservation_number.present? && event.client.auto_reservation_numbers_start.present? &&
      seller.default_reservation_number < event.client.auto_reservation_numbers_start &&
      !event.reservations.exists?(number: seller.default_reservation_number)
  end

  def within_reservation_period
    errors.add :base, :too_early unless event.present? && Time.now >= event.reservation_start
    errors.add :base, :too_late unless event.present? && Time.now <= event.reservation_end
  end

  def capacity_available
    errors.add :base, :limit_reached unless event.present? && event.reservations.size < event.max_reservations
  end

  def max_reservations_per_seller
    return if event.nil?

    max_reservations = event.max_reservations_per_seller
    reservations = event.reservations.where(seller: seller).where.not(id: id)
    return if reservations.count < max_reservations

    errors.add :event, :limit, limit: max_reservations
  end

  def not_suspended
    return if event.nil? || seller.nil?

    suspension = event.suspensions.find_by(seller: seller)
    errors.add :event, :suspended, reason: suspension.reason if suspension
  end

  def reservation_allowed_by_seller
    return if event.nil?

    errors.add :base, :forbidden if event.client.reservation_by_seller_forbidden?
  end
end
