# frozen_string_literal: true

FactoryBot.define do
  factory :base_event, class: :event do
    transient do
      shopping_time { 1.week.from_now }
      shopping_start { shopping_time }
      shopping_end { shopping_start + 2.hours }
    end

    sequence(:name) { |n| "Event #{n}" }
    max_sellers 10
    reservation_start { 1.day.from_now }
    reservation_end { shopping_time - 1.day }
    seller_fee 2

    after :build do |event, evaluator|
      event.shopping_periods << build(:shopping_period, event: event,
                                                        min: evaluator.shopping_start, max: evaluator.shopping_end)
    end

    factory :event do
      kind :commissioned
      max_items_per_reservation 5
      price_precision 0.1
      commission_rate 0.2

      factory :event_with_ongoing_reservation do
        reservation_start { 1.day.ago }
        reservation_end { 1.day.from_now }

        factory :full_event do
          max_sellers 1
          after :create do |event|
            create :reservation, event: event
          end
        end
      end
      after :build do |event, evaluator|
        event.handover_periods << build(:handover_period, event: event, min: event.reservation_end + 1.hour)
        event.pickup_periods << build(:pickup_period, event: event, min: evaluator.shopping_time + 1.day)
      end
    end

    factory :direct_event do
      kind :direct
    end
  end
end
