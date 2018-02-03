# frozen_string_literal: true

FactoryBot.define do
  factory :transaction_item do
    association :item_transaction, factory: :transaction
    item
  end
end
