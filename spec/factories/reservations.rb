FactoryGirl.define do
  factory :reservation do
    event factory: :event_with_ongoing_reservation
    seller
    sequence(:number) { |n| n }
  end
end
