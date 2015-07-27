FactoryGirl.define do
  factory :time_period do
    min { 1.week.from_now }
    max { min + 2.hours }
    factory :shopping_period do
      kind :shopping
    end

    factory :handover_period do
      kind :handover
    end
  end
end
