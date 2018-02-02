# frozen_string_literal: true

FactoryBot.define do
  factory :base_transaction, class: :transaction do
    event
    number SecureRandom.uuid

    factory :sale_transaction, aliases: [:transaction] do
      after :build, &:sale!
    end

    factory :refund_transaction do
      after :build, &:refund!
    end
  end
end
