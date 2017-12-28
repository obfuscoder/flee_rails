# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    client Client.first
    sequence(:name) { |n| "Category #{n}" }

    factory :category_with_enforced_donation do
      donation_enforced true
    end
  end
end
