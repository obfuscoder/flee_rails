class Item < ActiveRecord::Base
  belongs_to :category
  belongs_to :reservation

  include ActionView::Helpers::NumberHelper

  validates_presence_of :category, :description, :price, :reservation
  validates_uniqueness_of :code, allow_nil: true
  validates :number, numericality: { greater_than: 0, only_integer: true },
                     uniqueness: { scope: :reservation_id },
                     allow_nil: true
  validates :price, numericality: { greater_than: 0 }
  validate :price_divisible_by_precision
  validate :max_number_of_items_for_category

  scope :without_label, -> { where { code.eq nil } }
  scope :with_label, -> { where { code.not_eq nil } }

  def self.search(needle)
    needle.nil? ? all : joins(:category).where do
      sift(:full_text_search, needle) | { category => sift(:full_text_search, needle) }
    end
  end

  def to_s
    description || super
  end

  def delete_code
    self.number = self.code = nil
    save!
  end

  def create_code(options = {})
    prefix = options.extract!(:prefix).values.first || ''
    self.number = reservation.items.with_label.order(:number).last.try(:number)
    if number.present?
      self.number += 1
    else
      self.number = 1
    end
    code = format('%s%02d%03d%03d', prefix, reservation.event.id, reservation.number, number)
    self.code = append_checksum(code)
  end

  def price=(number)
    number.tr!(',', '.') if number.is_a? String
    self[:price] = number
  end

  private

  def append_checksum(code)
    bytes = code.reverse.bytes.each_with_index.map { |byte, index| digit_sum(byte * weight(index)) }
    checksum = bytes.reduce(:+) % 10
    code + checksum.to_s
  end

  def weight(index)
    index % 2 + 1
  end

  def digit_sum(value)
    value.to_s.chars.map(&:to_i).reduce(:+)
  end

  def price_divisible_by_precision
    return if reservation.nil? || reservation.event.nil? || price.nil?
    precision = reservation.event.price_precision
    errors.add :price, :precision, precision: number_to_currency(precision) if price.remainder(precision).nonzero?
  end

  def max_number_of_items_for_category
    return unless reservation.present? && category.present? && category.max_items_per_seller.present?
    items_with_category = reservation.items.where(category: category).where.not(id: id)
    return if items_with_category.count < category.max_items_per_seller
    errors.add :category, :limit, limit: category.max_items_per_seller
  end

  sifter :full_text_search do |needle|
    pattern = "%#{needle}%"
    description.matches(pattern) |
      size.matches(pattern) |
      price.matches(pattern)
  end
end
