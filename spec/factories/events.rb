FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    max_sellers 1
  end
end
