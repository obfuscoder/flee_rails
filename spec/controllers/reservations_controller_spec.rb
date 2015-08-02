require 'rails_helper'

describe ReservationsController do
  describe 'GET create' do
    let(:event) { FactoryGirl.create :event }
    let(:seller) { FactoryGirl.build :seller }
    let(:action) { get :create, event_id: event.id }
    let(:reservation) { FactoryGirl.create :reservation }
    let(:from) { Settings.brands.default.mail.from }
    let(:creator) { double }
    let(:options) { { host: 'test.host', from: from } }

    before do
      expect(subject).to receive(:current_seller).and_return seller
      expect(Reservations::CreateReservation).to receive(:new).and_return creator
      expect(creator).to receive(:create).with(event, seller, {}, options).and_return reservation
      action
    end

    it { is_expected.to redirect_to seller_path }
    it 'notifies about the reservation' do
      expect(flash[:notice]).to be_present
    end

    context 'when reservation was not persisted' do
      let(:reservation) { FactoryGirl.build :reservation }
      it { is_expected.to redirect_to seller_path }
      it 'alerts about the failed reservation' do
        expect(flash[:alert]).to be_present
      end
    end
  end
end
