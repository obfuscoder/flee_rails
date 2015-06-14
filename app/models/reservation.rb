class Reservation < ActiveRecord::Base
  belongs_to :seller
  belongs_to :event
  has_many :items, dependent: :destroy

  validates_presence_of :seller, :event, :number
  validates :number, numericality: { greater_than: 0, only_integer: true }, uniqueness: { scope: :event_id }
  validates :seller_id, uniqueness: { scope: :event_id }

  validate :within_reservation_period, on: :create
  validate :capacity_available, on: :create

  before_validation :create_number

  def to_s
    "#{event.name} - #{number}"
  end

  private

  def create_number
    return if event.nil? || number.present?
    current_max = event.reservations.maximum(:number) || 0
    self.number = current_max + 1
  end

  def within_reservation_period
    errors.add :base, :too_early unless event.present? && Time.now >= event.reservation_start
    errors.add :base, :too_late unless event.present? && Time.now <= event.reservation_end
  end

  def capacity_available
    errors.add :base, :limit_reached unless event.present? && event.reservations.size < event.max_sellers
  end
end
