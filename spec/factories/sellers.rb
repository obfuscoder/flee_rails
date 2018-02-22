# frozen_string_literal: true

FactoryBot.define do
  factory :seller do
    client { Client.first }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    street { Faker::Address.street_address }
    zip_code { Faker::Address.zip }
    city { Faker::Address.city }
    phone { Faker::PhoneNumber.phone_number }
    mailing true
    email { Faker::Internet.email }
    sequence(:token) { |n| "token#{n}" }
    active true

    factory :random_seller do
      created_at { Faker::Time.between 10.days.ago, Time.now }
    end
  end
end
