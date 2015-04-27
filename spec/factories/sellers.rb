FactoryGirl.define do
  factory :seller do
    first_name 'Firstname'
    last_name 'Lastname'
    street 'Street'
    zip_code '12345'
    city 'City'
    phone '0815/4711'
    mailing true

    sequence(:email) { |n| "email#{n}@example.com" }
    sequence(:token) { |n| "token#{n}" }
  end
end
