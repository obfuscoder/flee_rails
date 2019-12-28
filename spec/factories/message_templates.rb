FactoryBot.define do
  factory :message_template do
    client { Client.first }
    sequence(:category) { |n| "category-#{n}" }
    subject { Faker::Lorem.sentence }

    body { Faker::Lorem.paragraphs.join "\n\n" }

    factory :registration_message_template do
      category { :registration }
    end

    factory :invitation_message_template do
      category { :invitation }
    end
  end
end
