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
        create_reservation = double :create_reservation
        first_seller = notifications.first.seller
        expect(CreateReservation).to receive(:new).and_return create_reservation
        expect(Reservation).to receive(:new).with(event: event, seller: first_seller).and_call_original
        expect(create_reservation).to receive(:call).with(instance_of(Reservation))
        subject.perform_action event
      end
    end
  end
end
