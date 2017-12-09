# frozen_string_literal: true

FactoryBot.define do
  factory :sold_stock_item do
    event
    stock_item
    amount { Faker::Number.between(1, 10) }
  end
end
