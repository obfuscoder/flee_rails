FactoryGirl.define do
  factory :item do
    category
    reservation
    sequence(:description) { |n| "Description #{n}" }
    price 1.9

    factory :item_with_code do
      after :build do |item, _evaluator|
        item.create_code
      end
    end

    factory :random_item do
      created_at { Faker::Time.between 10.days.ago, Time.now }
      description { Faker::Lorem.words(4).join(' ') }
      price { Faker::Number.decimal 1, 1 }
    end
  end
end
