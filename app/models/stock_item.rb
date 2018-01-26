# frozen_string_literal: true

class StockItem < ActiveRecord::Base
  belongs_to :client

  has_many :sold_stock_items, dependent: :restrict_with_error
  has_many :events, through: :sold_stock_items

  validates :client, :description, :price, :number, :code, presence: true
  validates :code, uniqueness: { scope: :client_id }
  validates :number, numericality: { greater_than: 0, only_integer: true }, uniqueness: { scope: :client_id }
  validates :price, numericality: { greater_than: 0 }

  after_initialize :create_number, :create_code

  private

  def create_number
    self.number ||= StockItem.count + 1
  end

  def create_code
    self.code ||= append_checksum(number.to_s)
  end

  def append_checksum(code)
    code + CalculateChecksum.new.call(code).to_s
  end
end
