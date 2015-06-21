FactoryGirl.define do
  factory :review do
    event
    seller

    factory :good_review do
      registration 1
      reservation 2
      print 1
      mailing 2
      content 2
      design 2
      support 2
      handover 2
      payoff 2
      organization 2
      total 1
      recommend true
      source 'internet'
    end

    factory :bad_review do
      registration 3
      reservation 3
      print 3
      mailing 3
      content 3
      design 5
      support 3
      handover 3
      payoff 2
      organization 3
      total 3
      recommend false
      source 'friends'
      to_improve 'Die Webseite sieht schlecht aus'
    end

    factory :incomplete_review do
      registration 2
      reservation 2
      print 1
      total 2
    end
  end
end
