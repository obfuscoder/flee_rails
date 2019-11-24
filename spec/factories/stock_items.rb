# frozen_string_literal: true

FactoryBot.define do
  factory :stock_item do
    client { Client.first }
    sequence(:description) { |n| "Description #{n}" }
    price { Faker::Number.decimal(l_digits: 1, r_digits: 1).to_d + 0.1 }
  end
end
