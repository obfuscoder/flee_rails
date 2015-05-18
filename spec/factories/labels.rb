FactoryGirl.define do
  factory :label do
    reservation
    item
    sequence(:number) { |n| n }
    sequence(:code) { |n| "code#{n}" }
  end
end
