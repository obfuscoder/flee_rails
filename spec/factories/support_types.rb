# frozen_string_literal: true

FactoryBot.define do
  factory :support_type do
    event
    sequence(:name) { |n| "Support type #{n}" }
    description { Faker::Lorem.paragraphs.join "\n\n" }
    capacity 5
  end
end
