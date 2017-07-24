# frozen_string_literal: true

FactoryGirl.define do
  factory :notification do
    event
    seller
  end
end
