# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :category, -> { with_deleted }, inverse_of: :items
  belongs_to :reservation
  has_many :transaction_items, dependent: :restrict_with_error
  has_many :item_transactions, through: :transaction_items

  include ActionView::Helpers::NumberHelper
  include Statistics

  # in rails 5 there is _prefix to get rid of the 'size_'
  enum gender: { male: 0, female: 1, both: 2 }

  validates :category, :description, :price, :reservation, presence: true
  validates :description, length: { maximum: 250 }
  validates :size, length: { maximum: 50 }
  validates :code, uniqueness: { scope: :reservation_id }, allow_nil: true
  validates :number, numericality: { greater_than: 0, only_integer: true },
                     uniqueness: { scope: :reservation_id },
                     allow_nil: true
  validates :price, numericality: { greater_than: 0 }
  validate :price_divisible_by_precision
  validate :max_number_of_items_for_category, on: %i[create update]
  validate :item_count_for_reservation, on: :create
  validate :size_required_for_category, on: %i[create update]
  validate :allowed_size_for_category, on: %i[create update]
  validate :size_disabled_for_category, on: %i[create update]
  validate :gender_required_for_category, on: %i[create update]

  scope :without_label, -> { where.has { code.eq nil } }
  scope :with_label, -> { where.has { code.not_eq nil } }
  scope :sold, -> { where.has { sold.not_eq nil } }
  scope :for_client, ->(client) { joins(reservation: :event).where.has { reservation.event.client_id.eq client.id } }

  attr_accessor :fixed_size # virtual attribute to allow fixed size selection

  def self.search(needle)
    return all if needle.nil?

    joins(:category).where.has { sift(:full_text_search, needle) | category.sift(:full_text_search, needle) }
  end

  def to_s
    description || super
  end

  def delete_code
    self.number = self.code = nil
    save! context: :delete_code
  end

  def create_code(options = {})
    prefix = options.extract!(:prefix).values.first || ''
    create_number
    code = format('%s%02d%03d%03d', prefix, reservation.event.number, reservation.number, number)
    self.code = append_checksum(code)
  end

  def price=(number)
    number.tr!(',', '.') if number.is_a? String
    self[:price] = number
  end

  private

  def append_checksum(code)
    code + CalculateChecksum.new.call(code).to_s
  end

  def price_divisible_by_precision
    return if reservation.nil? || reservation.event.nil? || price.nil?

    precision = reservation.event.price_precision
    errors.add :price, :precision, precision: number_to_currency(precision) if price.remainder(precision).nonzero?
  end

  def max_number_of_items_for_category
    return if reservation.blank?
    return if reservation.category_limits_ignored?

    most_limited_category = category.try(:most_limited_category)
    return unless category.present? && most_limited_category.present?

    items_with_category = reservation.items.where(category: most_limited_category.self_and_descendants).where.not id: id
    return if items_with_category.count < most_limited_category.max_items_per_seller

    errors.add :category, :limit, limit: most_limited_category.max_items_per_seller,
                                  category: most_limited_category.name
  end

  def item_count_for_reservation
    return if reservation.blank?

    errors.add :base, :limit_reached if reservation.items.count >= reservation.max_items
  end

  def allowed_size_for_category
    return if category.nil?
    return unless category.size_fixed? && category.sizes.include?(size)

    errors.add :size, :fixed
  end

  def size_required_for_category
    return if category.nil?
    return unless category.size_required? && size.blank?

    errors.add :size, :required
  end

  def size_disabled_for_category
    return if category.nil?
    return unless category.size_disabled? && size.present?

    errors.add :size, :disabled
  end

  def gender_required_for_category
    return if category.nil?
    return unless category.gender? && gender.blank?

    errors.add :gender, :required
  end

  def create_number
    self.number = reservation.reload.increase_label_counter
  end

  sifter :full_text_search do |needle|
    pattern = "%#{needle}%"
    description.matches(pattern) | size.matches(pattern) | price.matches(pattern)
  end
end
