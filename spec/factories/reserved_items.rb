FactoryGirl.define do
  factory :reserved_item do
    reservation
    item
    sequence(:number) { |n| n }
    sequence(:code) { |n| "code#{n}" }
  end
end
