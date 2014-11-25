FactoryGirl.define do
  factory :reservation, aliases: [:ongoing_reservation] do
    event factory: :event_with_ongoing_reservation
    seller
    sequence(:number) { |n| n }
  end

  factory :ongoing_reservation_for_commission_event, parent: :reservation do
    event factory: :event_with_ongoing_reservation, kind: 'commission'
  end

  factory :ongoing_reservation_for_direct_event, parent: :reservation do
    event factory: :event_with_ongoing_reservation, kind: 'direct'
  end

  factory :reservation_with_passed_event, parent: :reservation do
    transient do
      kind 'commission'
    end
    event factory: :passed_event
    after :build do |reservation, evaluator|
      reservation.event.kind = evaluator.kind
    end
  end
end
