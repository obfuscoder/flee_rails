class ReservedItem < ActiveRecord::Base
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

  def create_number
    self.number = reservation.reserved_items.count + 1 if number.nil? && reservation.present?
  end

  def create_code
    return if number.nil? || reservation.nil?
    code = format('%03d%03d', reservation.number, number)
    self.code = append_checksum(code)
  end

  def append_checksum(code)
    code
  end
end
