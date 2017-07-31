# frozen_string_literal: true

FactoryGirl.define do
  factory :stock_item do
    sequence(:description) { |n| "Description #{n}" }
    price { Faker::Number.decimal 1, 1 }
  end
end
