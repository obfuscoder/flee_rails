# frozen_string_literal: true

FactoryGirl.define do
  factory :suspension do
    event
    seller
    sequence(:reason) { |n| "reason #{n}" }
  end
end
