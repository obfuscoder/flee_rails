# frozen_string_literal: true

class StockItem < ActiveRecord::Base
  has_many :sold_stock_items
  has_many :events, through: :sold_stock_items

  validates_presence_of :description, :price, :number, :code
  validates_uniqueness_of :code
  validates :number, numericality: { greater_than: 0, only_integer: true }, uniqueness: true
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