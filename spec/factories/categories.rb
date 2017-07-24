# frozen_string_literal: true

FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }

    factory :category_with_enforced_donation do
      donation_enforced true
    end
  end
end
