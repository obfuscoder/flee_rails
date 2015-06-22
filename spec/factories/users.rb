FactoryGirl.define do
  factory :user, aliases: [:admin] do
    sequence(:email) { |n| "admin#{n}@example.com" }
    password 'password'
  end
end
