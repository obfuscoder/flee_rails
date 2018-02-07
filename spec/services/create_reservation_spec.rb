# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateReservation do
  subject(:instance) { described_class.new }
  describe '#create' do
    subject(:action) { instance.create event, seller }

    let(:event) { double :event, notifications: notifications }
    let(:seller) { double :seller }
    let(:reservation) { double :reservation, save: true }
    let(:notifications) { double :notification, where: relevant_notifications }
    let(:relevant_notifications) { double :relevant_notifications, destroy_all: nil }
    let(:options) { {} }
    before do
      allow(Reservation).to receive(:new).and_return(reservation)
      allow(SellerMailer).to receive(:reservation).and_return double(deliver_later: true)
    end
    it 'creates a reservation' do
      action
      expect(Reservation).to have_received(:new).with(hash_including(event: event, seller: seller))
    end

    it { is_expected.to eq reservation }

    context 'when reservation was persisted' do
      it 'sends reservation confirmation mail' do
        mailer = double
        expect(SellerMailer).to receive(:reservation).with(reservation).and_return mailer
        expect(mailer).to receive(:deliver_later)
        action
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
      expect(reservation).to receive(:save).with(options).and_return(reservation)
      instance.create event, seller, options
    end
  end
end
