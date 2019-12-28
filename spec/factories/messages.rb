FactoryBot.define do
  factory :message do
    event

    factory :invitation_message do
      category { :invitation }
    end

    factory :reservation_closing_message do
      category { :reservation_closing }
    end

    factory :reservation_closed_message do
      category { :reservation_closed }
    end
  end
end
