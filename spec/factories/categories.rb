# frozen_string_literal: true

FactoryBot.define do
  factory :category, aliases: [:category_with_size_optional] do
    client { Client.first }
    sequence(:name) { |n| "Category #{n}" }
    size_option :size_optional

    factory :category_with_enforced_donation do
      donation_enforced true
    end

    factory :category_with_size_required do
      size_option :size_required
    end

    factory :category_with_size_disabled do
      size_option :size_disabled
    end

    factory :category_with_size_fixed do
      size_option :size_fixed

      factory :category_with_fixed_sizes do
        transient do
          size_count 5
        end

        after :build do |category, evaluator|
          evaluator.size_count.times { category.sizes << build(:size, category: category) }
        end
      end
    end
  end
end
