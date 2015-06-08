FactoryGirl.define do
  factory :item do
    category
    reservation
    description 'Description'
    price 1.9

    factory :item_with_code do
      after :build do |item, _evaluator|
        item.create_code
      end
    end
  end
end
