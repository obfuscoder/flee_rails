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
      allow(CreateReservationOrder).to receive(:new).and_return creator
      action
    end

    it 'calls creator with reservation' do
      expect(creator).to have_received(:call).with(instance_of(Reservation))
    end

    it { is_expected.to redirect_to seller_path }
    it 'notifies about the created reservation order' do
      expect(flash[:notice]).to be_present
    end

    context 'when returned reservation had errors' do
      let(:error_message) { 'some error' }
      let(:reservation) { double errors: double(any?: true, full_messages: [error_message]) }

      it { is_expected.to redirect_to seller_path }
      it 'alerts about the failed reservation' do
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to include error_message
      end
    end
  end
end
