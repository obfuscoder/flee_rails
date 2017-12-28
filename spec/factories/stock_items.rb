# frozen_string_literal: true

FactoryBot.define do
  factory :stock_item do
    client Client.first
    sequence(:description) { |n| "Description #{n}" }
    price { Faker::Number.decimal(1, 1).to_d + 0.1 }
  end
end
