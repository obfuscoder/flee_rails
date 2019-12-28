FactoryBot.define do
  factory :stock_message_template do
    sequence(:category) { |n| "category-#{n}" }
    subject { Faker::Lorem.sentence }

    body { Faker::Lorem.paragraphs.join "\n\n" }
  end
end
