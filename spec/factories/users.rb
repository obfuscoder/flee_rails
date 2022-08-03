FactoryBot.define do
  factory :user, aliases: [:admin] do
    client { Client.first }
    sequence(:email) { |n| format('admin%04d@example.com', n) }
    sequence(:name) { |n| format('User %04d', n) }
    password { 'Admin123' }
  end
end
