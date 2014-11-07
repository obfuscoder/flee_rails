FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    max_sellers 1
    shopping_start 1.week.from_now
    shopping_end 1.week.from_now + 2.hours
  end

  factory :event_with_ongoing_reservation, parent: :event do
    reservation_start 1.day.ago
    reservation_end 1.day.from_now
  end

  factory :full_event, parent: :event_with_ongoing_reservation do
    after :create do |event|
      create :reservation, event: event
    end
  end
end
