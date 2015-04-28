class Event < ActiveRecord::Base
  enum kind: [:commission, :direct]
  has_many :reservations, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates_presence_of :name
  validates :max_sellers, numericality: { greater_than: 0, only_integer: true }

  scope :reservation_started, -> { where { reservation_start <= Time.now } }
  scope :reservation_not_yet_ended, -> { where { reservation_end >= Time.now } }
  scope :within_reservation_time, -> { reservation_started.reservation_not_yet_ended }
  scope :without_reservation_for, ->(seller) { where { id << seller.reservations.map(&:event_id) } }

  def self.with_available_reservations
    joins { reservations.outer }.group(:id).having { count(reservations.id) < max_sellers }
  end

  def self.reservable_by(seller)
    without_reservation_for(seller).within_reservation_time.with_available_reservations
  end

  def reviewed_by?(seller)
    reviews.any? { |review| review.seller == seller }
  end

  def to_s
    name || super
  end
end
