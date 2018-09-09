# frozen_string_literal: true

require 'rails_helper'

describe ReservationsController do
  describe 'GET create' do
    let(:event) { create :event }
    let(:seller) { build :seller }
    let(:action) { get :create, event_id: event.id }
    let(:reservation) { create :reservation }
    let(:creator) { double call: reservation }
    let(:options) { { host: 'demo.test.host', from: from } }

    before do
      allow(controller).to receive(:current_seller).and_return seller
      allow(CreateReservation).to receive(:new).and_return creator
      action
    end

    it 'calls creator with reservation' do
      expect(creator).to have_received(:call).with(instance_of(Reservation))
    end

    it { is_expected.to redirect_to seller_path }
    it 'notifies about the reservation' do
      expect(flash[:notice]).to be_present
    end

    context 'when reservation was not persisted' do
      let(:reservation) { build :reservation }

      it { is_expected.to redirect_to seller_path }
      it 'alerts about the failed reservation' do
        expect(flash[:alert]).to be_present
      end
    end
  end
end
