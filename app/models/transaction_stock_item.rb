# frozen_string_literal: true

class TransactionStockItem < ApplicationRecord
  belongs_to :item_transaction, class_name: 'Transaction',
                                foreign_key: :transaction_id,
                                inverse_of: :transaction_stock_items
  belongs_to :stock_item

  validates :stock_item, presence: true, uniqueness: { scope: :transaction_id }
  validates :item_transaction, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0, only_integer: true }
end
