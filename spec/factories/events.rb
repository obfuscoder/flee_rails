FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    max_sellers 1
    max_items_per_seller 5
    shopping_start 1.week.from_now
    shopping_end { shopping_start + 2.hours }
    reservation_start 1.day.from_now
    reservation_end { shopping_start - 1.day }
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
