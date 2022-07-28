FactoryBot.define do
  factory :base_event, class: :event do
    client { Client.first }
    transient do
      shopping_time { 1.week.from_now }
      shopping_start { shopping_time }
      shopping_end { shopping_start + 2.hours }
    end

    sequence(:name) { |n| "Event #{n}" }
    sequence(:details) { |n| "Event details #{n}" }
    max_reservations { 10 }
    reservation_start { 1.day.from_now }
    reservation_end { shopping_time - 1.day }
    reservation_fee { 2 }

    after :build do |event, evaluator|
      event.shopping_periods << build(:shopping_period, event: event,
                                                        min: evaluator.shopping_start, max: evaluator.shopping_end)
    end

    factory :event do
      kind { :commissioned }
      max_items_per_reservation { 50 }
      price_precision { 0.1 }
      commission_rate { 0.2 }

      factory :event_with_ongoing_reservation do
        reservation_start { 1.day.ago }
        reservation_end { 1.day.from_now }

        factory :full_event do
          max_reservations { 1 }
          after :create do |event|
            create :reservation, event: event
          end
        end

        factory :billable_event do
          transient { shopping_time { 1.day.ago } }

          after :build do |event|
            reservation = build :reservation, event: event
            event.reservations << reservation
            reservation.items << build_list(:sold_item, 10, reservation: reservation)
            event.rentals << build(:rental, event: event, hardware: Hardware.first)
            event.rentals << build(:rental, event: event, hardware: Hardware.second)
            event.rentals << build(:rental, event: event, hardware: Hardware.third, amount: 4)
          end
        end
      end

      factory :event_with_price_factor do
        price_factor { 1.1 }
      end

      factory :event_with_support do
        support_system_enabled { true }
        supporters_can_retire { true }
        after :build do |event|
          event.support_types << build(:support_type, event: event)
        end

        factory :event_with_support_disabled do
          support_system_enabled { false }
        end

        factory :event_with_support_full do
          after :build do |event|
            event.support_types.each do |support_type|
              create_list :supporter, support_type.capacity, support_type: support_type
            end
          end
        end
      end

      after :build do |event, evaluator|
        event.handover_periods << build(:handover_period, event: event, min: event.reservation_end + 1.hour)
        event.pickup_periods << build(:pickup_period, event: event, min: evaluator.shopping_time + 1.day)
      end
    end

    factory :direct_event do
      kind { :direct }
    end
  end
end
