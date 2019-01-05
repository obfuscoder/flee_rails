# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    topic { Faker::Lorem.words(5).join(' ') }
    body { Faker::Lorem.paragraphs(5).join("\n\n") }
  end
end
