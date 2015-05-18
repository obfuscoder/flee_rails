FactoryGirl.define do
  factory :item do
    seller
    category
    description 'Description'
    price 1.9

    factory :item_with_label do
      after :create do |item, _evaluator|
        reservation = create :reservation, seller: item.seller
        create :label, item: item, reservation: reservation
      end
    end
  end
end
