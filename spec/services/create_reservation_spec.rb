# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateReservation do
  subject(:instance) { described_class.new }

  describe '#call' do
    subject(:action) { instance.call reservation }

    let(:event) { double :event, notifications: notifications }
    let(:seller) { double :seller }
    let(:reservation) { double :reservation, event: event, seller: seller, save: true }
    let(:notifications) { double :notification, find_by: found_notification }
    let(:found_notification) { double :found_notification, destroy: nil }
    let(:mailer) { double deliver_later: nil }
    let(:options) { {} }

    before do
      allow(SellerMailer).to receive(:reservation).and_return mailer
      allow(SellerMailer).to receive(:reservation_failed).and_return mailer
    end

    it 'saves the reservation' do
      action
      expect(reservation).to have_received(:save)
    end

    it { is_expected.to eq reservation }

    context 'when reservation was persisted' do
      it 'sends reservation confirmation mail' do
        action
        expect(SellerMailer).to have_received(:reservation).with(reservation)
        expect(mailer).to have_received(:deliver_later)
      end
    end

    context 'when reservation was not persisted' do
      let(:reservation) { double :unsaved_reservation, event: event, seller: seller, save: false }

      it 'does not send reservation confirmation mail' do
        action
        expect(SellerMailer).not_to have_received(:reservation)
      end

      it 'sends reservation failed mail' do
        action
        expect(SellerMailer).not_to have_received(:reservation_failed).with(:notification)
      end
    end

    it 'removes all notifications for this event and seller' do
      action
      expect(event).to have_received(:notifications)
      expect(notifications).to have_received(:find_by).with(seller: seller)
      expect(found_notification).to have_received(:destroy)
    end

    it 'passes on provided options to save' do
      options = { context: :admin }
      allow(reservation).to receive(:save).and_return(reservation)
      instance.call reservation, options
      expect(reservation).to have_received(:save).with(options)
    end
  end

  describe '#delayed' do
    subject(:action) { instance.delayed reservation }

    let(:event) { double :event, id: 2 }
    let(:seller) { double :seller, id: 3 }
    let(:reservation) { double :reservation, event: event, seller: seller }

    it 'creates a delayed job' do
      expect { action }.to change { Delayed::Job.count }.by 1
    end
  end

  describe '#delayed_call' do
    subject(:action) { instance.delayed_call event.id, seller.id }

    let(:event) { double :event, id: 2 }
    let(:seller) { double :seller, id: 3 }
    let(:reservation) { double :reservation, event: event, seller: seller }

    before do
      allow(Event).to receive(:find).with(event.id).and_return event
      allow(Seller).to receive(:find).with(seller.id).and_return seller
      allow(Reservation).to receive(:new).with(seller: seller, event: event).and_return reservation
      allow(instance).to receive(:call)
    end

    it 'calls call' do
      action
      expect(instance).to have_received(:call).with(reservation, {})
    end
  end
end
