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
  end
end
