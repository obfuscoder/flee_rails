# frozen_string_literal: true

FactoryGirl.define do
  factory :rental do
    event
    hardware
    amount 1
  end
end
