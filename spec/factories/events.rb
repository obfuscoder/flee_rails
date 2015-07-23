FactoryGirl.define do
  factory :base_event, class: :event do
    transient do
      shopping_time { 1.week.from_now }
      shopping_start { shopping_time }
      shopping_end { shopping_start + 2.hours }
    end

    sequence(:name) { |n| "Event #{n}" }
    max_sellers 1
    reservation_start { 1.day.from_now }
    reservation_end { shopping_time - 1.day }
    seller_fee 2

    after :build do |event, evaluator|
      event.shopping_periods << build(:shopping_period, event: event,
                                                        min: evaluator.shopping_start, max: evaluator.shopping_end)
    end

    factory :event do
      max_items_per_seller 5
      handover_start { reservation_end + 1.hour }
      handover_end { handover_start + 2.hours }
      pickup_start { shopping_time + 1.day }
      pickup_end { pickup_start + 2.hours }
      price_precision 0.1
      commission_rate 0.2

      factory :event_with_ongoing_reservation do
        reservation_start { 1.day.ago }
        reservation_end { 1.day.from_now }

        factory :full_event do
          after :create do |event|
            create :reservation, event: event
          end
        end
      end
    end

    factory :direct_event do
      kind 'direct'
    end
  end
end
