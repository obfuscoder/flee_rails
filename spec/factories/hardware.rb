# frozen_string_literal: true

FactoryGirl.define do
  factory :hardware do
    sequence(:description) { |n| "Hardware #{n}" }
    price 5

    factory :scanner do
      description 'Scanner'
    end

    factory :router do
      description 'Router'
    end

    factory :repeater do
      description 'Repeater'
    end
  end
end
