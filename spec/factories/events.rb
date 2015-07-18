FactoryGirl.define do
  factory :base_event, class: :event do
    sequence(:name) { |n| "Event #{n}" }
    max_sellers 1
    shopping_start 1.week.from_now
    shopping_end { shopping_start + 2.hours }
    reservation_start 1.day.from_now
    reservation_end { shopping_start - 1.day }
    seller_fee 2

    factory :event do
      max_items_per_seller 5
      handover_start { reservation_end + 1.hour }
      handover_end { handover_start + 2.hours }
      pickup_start { shopping_end + 2.hours }
      pickup_end { pickup_start + 2.hours }
      price_precision 0.1
      commission_rate 0.2

      factory :event_with_ongoing_reservation do
        reservation_start 1.day.ago
        reservation_end 1.day.from_now

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
