# frozen_string_literal: true

FactoryBot.define do
  factory :email do
    seller
    subject { Faker::Lorem.sentence }

    body { Faker::Lorem.paragraphs.join "\n\n" }
    kind { :custom }
    from { Faker::Internet.email }
    to { Faker::Internet.email }
  end
end
