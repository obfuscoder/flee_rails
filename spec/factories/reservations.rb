FactoryGirl.define do
  factory :reservation do
    event
    seller
    sequence(:number) { |n| n }
  end
end
