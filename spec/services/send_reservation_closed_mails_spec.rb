require 'rails_helper'

RSpec.describe SendReservationClosedMails do
  subject(:instance) { described_class.new event }

  let(:event) { double :event, reservations: reservations, messages: messages }

  describe '#call' do
    subject(:action) { instance.call }

    let(:reservation1) { double :reservation1 }
    let(:reservation2) { double :reservation2 }
    let(:reservations) { [reservation1, reservation2] }
    let(:messages) { double :messages, create: nil }
    let(:admin_mailer) { double deliver_later: nil }

    before do
      allow(SendReservationClosedJob).to receive :perform_later
      allow(AdminMailer).to receive(:event_upcoming).and_return admin_mailer
    end

    it { is_expected.to eq reservations.count }

    it 'creates messages entry' do
      action
      expect(messages).to have_received(:create).with category: :reservation_closed, scheduled_count: reservations.count
    end

    it 'sends mails in background' do
      action
      reservations.each do |reservation|
        expect(SendReservationClosedJob).to have_received(:perform_later).with(reservation)
      end
    end

    it 'triggers admin mailer for upcoming event' do
      action
      expect(AdminMailer).to have_received(:event_upcoming).with(event)
      expect(admin_mailer).to have_received(:deliver_later)
    end
  end
end
