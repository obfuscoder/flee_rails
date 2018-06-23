# frozen_string_literal: true

FactoryBot.define do
  factory :size do
    category
    sequence(:value) { |n| "size #{n}" }
  end
end
