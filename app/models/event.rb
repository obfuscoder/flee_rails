class Event < ActiveRecord::Base
  enum kind: [:commission, :direct]
  has_many :reservations, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates_presence_of :name, :max_sellers, :max_items_per_seller, :price_precision, :commission_rate
  validates :price_precision, numericality: { greater_than_or_equal_to: 0.1, less_than_or_equal_to: 1 }
  validates :commission_rate, numericality: { greater_than_or_equal_to: 0.0, less_than: 1 }
  validates :max_sellers, numericality: { greater_than: 0, only_integer: true }
  validates :max_items_per_seller, numericality: { greater_than: 0, only_integer: true }

  scope :reservation_started, -> { where { reservation_start <= Time.now } }
  scope :reservation_not_yet_ended, -> { where { reservation_end >= Time.now } }
  scope :within_reservation_time, -> { reservation_started.reservation_not_yet_ended }
  scope :without_reservation_for, ->(seller) { where { id << seller.reservations.map(&:event_id) } }
  scope :current_or_upcoming, -> { where { shopping_end >= Time.now } }

  def self.with_available_reservations
    joins { reservations.outer }.group(:id).having { count(reservations.id) < max_sellers }
  end

  def self.reservable_by(seller)
    without_reservation_for(seller).within_reservation_time.with_available_reservations
  end

  def reviewed_by?(seller)
    reviews.any? { |review| review.seller == seller }
  end

  def reservations_left
    [max_sellers - reservations.count, 0].max
  end

  def to_s
    name || super
  end
end
