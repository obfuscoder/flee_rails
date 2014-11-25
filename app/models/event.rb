class Event < ActiveRecord::Base
  enum kind: [:commission, :direct]
  has_many :reservations, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates_presence_of :name
  validates :max_sellers, numericality: { greater_than: 0, only_integer: true }

  scope :within_reservation_time, -> do
    where{reservation_start <= Time.now}.where{reservation_end >= Time.now}
  end

  scope :with_available_reservations, -> do
    joins{reservations.outer}.group(:id).having{count(reservations.id) < max_sellers}
  end

  scope :reservable_by, -> (seller) do
    where{id << seller.reservations.map(&:event_id)}.within_reservation_time.with_available_reservations
  end

  scope :without_reservation_for, -> (seller) do
    where{id << seller.reservations.map(&:event_id)}
  end

  def reviewed_by?(seller)
    reviews.any? { |review| review.seller == seller }
  end

  def to_s
    name || super
  end
end
