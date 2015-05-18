class Label < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :item

  validates_presence_of :reservation, :item, :number, :code
  validates :number, numericality: { greater_than: 0, only_integer: true }, uniqueness: { scope: :reservation_id }
  validates :item_id, uniqueness: { scope: :reservation_id }
  validates_uniqueness_of :code

  before_validation(on: :create) do
    create_number
    create_code
  end

  def to_s
    "#{reservation.number} - #{number}"
  end

  private

  def create_number
    self.number = reservation.labels.count + 1 if number.nil? && reservation.present?
  end

  def create_code
    return if number.nil? || reservation.nil?
    code = format('%02d%03d%03d', reservation.event.id, reservation.number, number)
    self.code = append_checksum(code)
  end

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
end
