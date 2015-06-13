FactoryGirl.define do
  factory :reservation, aliases: [:ongoing_reservation] do
    event factory: :event_with_ongoing_reservation
    seller
    sequence(:number) { |n| n }

    factory :ongoing_reservation_for_commission_event do
      event factory: :event_with_ongoing_reservation, kind: 'commission'
    end

    factory :ongoing_reservation_for_direct_event do
      event factory: :event_with_ongoing_reservation, kind: 'direct'
    end
  end
end
