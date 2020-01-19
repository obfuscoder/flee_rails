require 'rails_helper'

RSpec.describe Receipt do
  subject(:receipt) { described_class.new reservation }

  let(:event) do
    create :event_with_ongoing_reservation, donation_of_unsold_items_enabled: true, price_precision: 0.5, gates: true
  end
  let(:seller) { create :seller }
  let(:reservation) { create :reservation, event: event, seller: seller, max_items: 100 }
  let!(:sold_items) { create_list :sold_item, 21, reservation: reservation, price: 3.5, checked_in: Time.now }
  let!(:returned_items) do
    create_list :item_with_code, 12, reservation: reservation, price: 1.5, checked_in: Time.now, checked_out: Time.now
  end
  let!(:donated_items) do
    create_list :item_with_code, 5, reservation: reservation, donation: true, price: 3.5, checked_in: Time.now
  end
  let!(:missing_items) { create_list :item_with_code, 7, reservation: reservation, price: 2.5 }
  let!(:lost_items) { create_list :item_with_code, 7, reservation: reservation, checked_in: Time.now, price: 4.0 }

  its(:seller) { is_expected.to eq seller }
  its(:event) { is_expected.to eq event }
  its(:reservation) { is_expected.to eq reservation }
  its(:sold_items) { is_expected.to eq sold_items }
  its(:returned_items) { is_expected.to eq returned_items }
  its(:gates?) { is_expected.to eq true }
  its(:donated_items) { is_expected.to eq donated_items }
  its(:lost_items) { is_expected.to eq lost_items }
  its(:missing_items) { is_expected.to eq missing_items }
  its(:reservation_fee) { is_expected.to eq(-event.reservation_fee) }
  its(:sold_items_sum) { is_expected.to eq 73.5 }
  its(:commission_cut) { is_expected.to eq(-15) }
  its(:payout) { is_expected.to eq 56.5 }

  context 'when precise_bill_amounts is true' do
    let(:event) do
      create :event_with_ongoing_reservation, donation_of_unsold_items_enabled: true, price_precision: 0.5,
                                              commission_rate: 0.25,
                                              precise_bill_amounts: true
    end

    its(:commission_cut) { is_expected.to eq(-18.38) }
    its(:payout) { is_expected.to eq 53.12 }
  end
end
