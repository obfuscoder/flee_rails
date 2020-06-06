FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    topic { Faker::Lorem.words(number: 5).join(' ') }
    body { Faker::Lorem.paragraphs(number: 5).join("\n\n") }
    sum { add1 + add2 }
  end
end
