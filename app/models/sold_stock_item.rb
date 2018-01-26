# frozen_string_literal: true

class SoldStockItem < ActiveRecord::Base
  belongs_to :event
  belongs_to :stock_item

  validates :event, :stock_item, :amount, presence: true
  validates :amount, numericality: { greater_than: 0, only_integer: true }
  validates :event_id, uniqueness: { scope: :stock_item_id }

  after_initialize do
    self.amount ||= 0
  end
end
