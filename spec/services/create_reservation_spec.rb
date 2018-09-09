# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateReservation do
  subject(:instance) { described_class.new }

  describe '#call' do
    subject(:action) { instance.call reservation }

    let(:event) { double :event, notifications: notifications }
    let(:seller) { double :seller }
    let(:reservation) { double :reservation, event: event, seller: seller, save: true }
    let(:notifications) { double :notification, where: relevant_notifications }
    let(:relevant_notifications) { double :relevant_notifications, destroy_all: nil }
    let(:options) { {} }

    before { allow(SellerMailer).to receive(:reservation).and_return double(deliver_now: true) }

    it 'saves the reservation' do
      action
      expect(reservation).to have_received(:save)
    end

    it { is_expected.to eq reservation }

    context 'when reservation was persisted' do
      it 'sends reservation confirmation mail' do
        mailer = double deliver_now: nil
        allow(SellerMailer).to receive(:reservation).and_return mailer
        action
        expect(SellerMailer).to have_received(:reservation).with(reservation)
        expect(mailer).to have_received(:deliver_now)
      end
    end

    context 'when reservation was not persisted' do
      let(:reservation) { double save: false }

      it 'does not send reservation confirmation mail' do
        action
        expect(SellerMailer).not_to have_received(:reservation)
      end
    end

    it 'removes all notifications for this event and seller' do
      action
      expect(event).to have_received(:notifications)
      expect(notifications).to have_received(:where).with(seller: seller)
      expect(relevant_notifications).to have_received(:destroy_all)
    end

    it 'passes on provided options to save' do
      options = { context: :admin }
      allow(reservation).to receive(:save).and_return(reservation)
      instance.call reservation, options
      expect(reservation).to have_received(:save).with(options)
    end
  end
end
