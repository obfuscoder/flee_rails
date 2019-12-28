FactoryBot.define do
  factory :base_transaction, class: :transaction do
    event
    number { SecureRandom.uuid }

    factory :purchase_transaction, aliases: [:transaction] do
      after :build, &:purchase!
    end

    factory :refund_transaction do
      after :build, &:refund!
    end
  end
end
