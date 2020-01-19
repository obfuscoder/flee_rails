FactoryBot.define do
  factory :item do
    category
    reservation
    sequence(:description) { |n| "Description #{n}" }
    price { 1.9 }

    factory :item_with_code do
      after :build do |item, _evaluator|
        item.create_code
      end
    end

    factory :sold_item do
      sold { Time.now }
    end

    factory :checked_in_item do
      checked_in { Time.now }

      factory :checked_out_item do
        checked_out { Time.now }
      end
    end

    factory :random_item do
      created_at { Faker::Time.between from: 10.days.ago, to: Time.now }
      description { Faker::Lorem.words(number: 4).join(' ') }
      price { Faker::Number.decimal l_digits: 1, r_digits: 1 }
    end
  end
end
