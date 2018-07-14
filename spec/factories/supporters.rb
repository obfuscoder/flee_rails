# frozen_string_literal: true

FactoryBot.define do
  factory :supporter do
    support_type
    seller
    comments { Faker::Lorem.sentence }
  end
end
