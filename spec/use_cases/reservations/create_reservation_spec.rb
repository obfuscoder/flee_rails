# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservations::CreateReservation do
  subject(:instance) { described_class.new }
  describe '#create' do
    let(:event) { double }
    let(:seller) { double }
    let(:reservation) { double save: true }
    let(:options) { {} }
    before do
      expect(Reservation).to receive(:new).with(hash_including(event: event, seller: seller)).and_return(reservation)
      allow(SellerMailer).to receive(:reservation).and_return double(deliver_later: true)
    end
    subject(:action) { instance.create event, seller }
    it 'returns the reservation' do
      expect(action).to eq reservation
    end

    context 'when reservation was persisted' do
      it 'sends reservation confirmation mail' do
        mailer = double
        expect(SellerMailer).to receive(:reservation).with(reservation, options).and_return mailer
        expect(mailer).to receive(:deliver_later)
        action
      end
    end

    context 'when reservation was not persisted' do
      let(:reservation) { double save: false }
      it 'does not send reservation confirmation mail' do
        expect(SellerMailer).not_to receive(:reservation)
        action
      end
    end

    it 'passes on provided options to save' do
      options = { context: :admin }
      expect(reservation).to receive(:save).with(options).and_return(reservation)
      instance.create event, seller, options
    end

    it 'passes on provided options to mailer' do
      options = { host: 'test.host' }
      expect(SellerMailer).to receive(:reservation).with(reservation, options).and_return double(deliver_later: true)
      instance.create event, seller, {}, options
    end
  end
end
