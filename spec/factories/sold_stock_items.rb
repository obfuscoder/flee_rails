FactoryBot.define do
  factory :sold_stock_item do
    event
    stock_item
    amount { Faker::Number.between(from: 1, to: 10) }
  end
end
