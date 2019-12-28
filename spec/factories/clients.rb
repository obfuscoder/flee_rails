FactoryBot.define do
  factory :client do
    sequence(:key) { |n| "key-#{n}" }
    sequence(:name) { |n| "Flohmarkt #{n}" }
    terms { '##Teilnahmebedingungen' }
    reservation_fee { 2.0 }
    price_precision { 0.1 }
    commission_rate { 0.2 }
  end
end
