# frozen_string_literal: true

FactoryGirl.define do
  factory :email do
    seller
    subject { Faker::Lorem.words.join ' ' }
    body { Faker::Lorem.paragraphs.join "\n\n" }
    kind :custom
    from { Faker::Internet.email }
    to { Faker::Internet.email }
  end
end
