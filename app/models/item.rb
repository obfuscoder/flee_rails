class Item < ActiveRecord::Base
  belongs_to :category
  belongs_to :reservation

  validates_presence_of :category, :description, :price, :reservation
  validates_uniqueness_of :code, allow_nil: true
  validates :number, numericality: { greater_than: 0, only_integer: true },
                     uniqueness: { scope: :reservation_id },
                     allow_nil: true

  scope :without_label, -> { where { code.eq nil } }
  scope :with_label, -> { where { code.not_eq nil } }

  def to_s
    description || super
  end

  def create_code
    self.number = reservation.items.with_label.count + 1
    code = format('%02d%03d%03d', reservation.event.id, reservation.number, number)
    self.code = append_checksum(code)
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
end
