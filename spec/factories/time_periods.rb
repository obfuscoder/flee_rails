# frozen_string_literal: true

FactoryGirl.define do
  factory :time_period do
    min { 1.week.from_now }
    max { min + 2.hours }
    factory :shopping_period do
      kind :shopping
    end

    factory :handover_period do
      kind :handover
    end

    factory :pickup_period do
      kind :pickup
    end
  end
end
