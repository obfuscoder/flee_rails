require 'rails_helper'

RSpec.describe InvitationQuery do
  subject(:instance) { described_class.new event }

  let(:event) { create :event, max_reservations_per_seller: max_reservations_per_seller }

  describe '#invitable_sellers' do
    subject(:action) { instance.invitable_sellers }

    let!(:reservable_seller) { create :seller }
    let!(:suspension) { create :suspension, event: event, seller: suspended_seller }
    let(:suspended_seller) { create :seller }
    let(:seller_with_reservation) { create :seller }
    let(:seller_with_max_reservations) { create :seller }
    let(:max_reservations_per_seller) { 2 }

    before do
      build(:reservation, seller: seller_with_reservation, event: event).save context: :admin
      build(:reservation, seller: seller_with_max_reservations, event: event).save context: :admin
      build(:reservation, seller: seller_with_max_reservations, event: event).save context: :admin
    end

    it { is_expected.to include reservable_seller }
    it { is_expected.to include seller_with_reservation }
    it { is_expected.not_to include suspended_seller }
    it { is_expected.not_to include seller_with_max_reservations }

    context 'when max_reservations_per_seller is nil' do
      let(:max_reservations_per_seller) { nil }

      it { is_expected.to include reservable_seller }
      it { is_expected.not_to include seller_with_reservation }
      it { is_expected.not_to include suspended_seller }
      it { is_expected.not_to include seller_with_max_reservations }
    end
  end
end
