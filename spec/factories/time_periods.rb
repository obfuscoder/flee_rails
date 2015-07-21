FactoryGirl.define do
  factory :shopping_period, class: :time_period do
    kind :shopping
    min 1.week.from_now
    max { min + 2.hours }
  end
end
