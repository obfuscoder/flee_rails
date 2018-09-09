# frozen_string_literal: true

FactoryBot.define do
  factory :transaction_stock_item do
    association :item_transaction, factory: :transaction
    stock_item
    amount { 1 }
  end
end
