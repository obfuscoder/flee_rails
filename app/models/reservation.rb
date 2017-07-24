# frozen_string_literal: true

class Reservation < ActiveRecord::Base
  belongs_to :seller, -> { with_deleted }
  belongs_to :event
  has_many :items, dependent: :destroy
  has_one :review, dependent: :destroy

  include Statistics

  validates_presence_of :seller, :event, :number
  validates :number, numericality: { greater_than: 0, only_integer: true }, uniqueness: { scope: :event_id }

  validate :within_reservation_period, on: :create
  validate :capacity_available, on: :create

  validate :max_reservations_per_seller, on: :create

  validates :max_items, numericality: { greater_than: 0, only_integer: true }

  before_validation :create_number

  def self.recent
    joins { event.shopping_periods }.where { event.shopping_periods.max >= 3.months.ago }.distinct.order do
      event.shopping_periods.max.desc
    end
  end

  def self.search(needle)
    needle.nil? ? all : joins(:seller).where { { seller => sift(:full_text_search, needle) } }
  end

  def to_s
    "#{event.name} - #{number}"
  end

  def increase_label_counter
    self.label_counter = [label_counter.to_i, Settings.number_start.to_i].max + 1
    save!
    label_counter
  end

  def commission_rate
    read_attribute(:commission_rate) || event.commission_rate
  end

  def fee
    read_attribute(:fee) || event.seller_fee
  end

  def max_items
    read_attribute(:max_items) || event.try(:max_items_per_reservation)
  end

  private

  def create_number
    return if event.nil? || number.present?

    current_max = [event.reservations.maximum(:number) || 0, Settings.number_start.to_i].max

    self.number = current_max + 1
  end

  def within_reservation_period
    errors.add :base, :too_early unless event.present? && Time.now >= event.reservation_start
    errors.add :base, :too_late unless event.present? && Time.now <= event.reservation_end
  end

  def capacity_available
    errors.add :base, :limit_reached unless event.present? && event.reservations.size < event.max_sellers
  end

  def max_reservations_per_seller
    return if event.nil?
    max_reservations = event.max_reservations_per_seller || 1
    reservations = event.reservations.where(seller: seller).where.not(id: id)
    return if reservations.count < max_reservations
    errors.add :event, :limit, limit: max_reservations
  end
end
