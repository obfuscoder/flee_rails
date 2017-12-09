# frozen_string_literal: true

FactoryBot.define do
  factory :suspension do
    event
    seller
    sequence(:reason) { |n| "reason #{n}" }
  end
end
