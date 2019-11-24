# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    reservation

    factory :good_review do
      registration { 1 }
      reservation_process { 2 }
      items { 1 }
      print { 1 }
      mailing { 2 }
      content { 2 }
      design { 2 }
      support { 2 }
      handover { 2 }
      payoff { 2 }
      sale { 1 }
      organization { 2 }
      total { 1 }
      recommend { true }
      source { 'internet' }
    end

    factory :bad_review do
      registration { 3 }
      reservation_process { 3 }
      print { 3 }
      mailing { 3 }
      content { 3 }
      design { 5 }
      support { 3 }
      handover { 3 }
      payoff { 2 }
      organization { 3 }
      total { 3 }
      recommend { false }
      source { 'friends' }
      to_improve { Faker::Lorem.sentence }
    end

    factory :random_review do
      registration { Faker::Number.between(from: 1, to: 3) }
      reservation_process { Faker::Number.between(from: 1, to: 3) }
      items { Faker::Number.between(from: 1, to: 3) }
      print { Faker::Number.between(from: 1, to: 3) }
      mailing { Faker::Number.between(from: 1, to: 3) }
      content { Faker::Number.between(from: 1, to: 3) }
      design { Faker::Number.between(from: 1, to: 3) }
      support { Faker::Number.between(from: 1, to: 3) }
      handover { Faker::Number.between(from: 1, to: 3) }
      payoff { Faker::Number.between(from: 1, to: 3) }
      sale { Faker::Number.between(from: 1, to: 3) }
      organization { Faker::Number.between(from: 1, to: 3) }
      total { Faker::Number.between(from: 1, to: 3) }
      recommend { true }
      source { %w[friends internet poster other][Faker::Number.between(from: 0, to: 3)] }
      to_improve { Faker::Lorem.sentence }
    end

    factory :incomplete_review do
      registration { 2 }
      reservation_process { 2 }
      print { 1 }
      sale { 2 }
      total { 2 }
    end
  end
end
