# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:admin] do
    client { Client.first }
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { 'password' }
  end
end
