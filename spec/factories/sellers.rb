FactoryGirl.define do
  factory :seller do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    street { Faker::Address.street_address }
    zip_code { Faker::Address.zip }
    city { Faker::Address.city }
    phone { Faker::PhoneNumber.phone_number }
    mailing true
    email { Faker::Internet.email }
    sequence(:token) { |n| "token#{n}" }
  end
end
