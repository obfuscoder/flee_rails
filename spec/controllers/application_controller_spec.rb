# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
  describe '#auto_reserve' do
    controller do
      def perform_action(event)
        auto_reserve(event)
      end
    end
    let(:event) { create :event_with_ongoing_reservation, max_reservations: 1 }

    context 'with two notifications' do
      let!(:notifications) { create_list :notification, 2, event: event }

      it 'creates reservation for first notification and keeps last notification' do
        create_reservation = double :create_reservation, call: nil
        first_seller = notifications.first.seller
        allow(CreateReservation).to receive(:new).and_return create_reservation
        allow(Reservation).to receive(:new).and_call_original
        controller.perform_action event
        expect(Reservation).to have_received(:new).with(event: event, seller: first_seller)
        expect(create_reservation).to have_received(:call).with(instance_of(Reservation))
      end
    end
  end
end
