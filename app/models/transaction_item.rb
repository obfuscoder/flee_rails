# frozen_string_literal: true

class TransactionItem < ActiveRecord::Base
  belongs_to :item_transaction, class_name: 'Transaction', foreign_key: :transaction_id, inverse_of: :transaction_items
  belongs_to :item

  validates :item, presence: true, uniqueness: { scope: :transaction_id }
  validates :item_transaction, presence: true
end
