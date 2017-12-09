# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    event
    seller
  end
end
