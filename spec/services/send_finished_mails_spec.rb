# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendFinishedMails do
  subject(:instance) { described_class.new event }
  let(:event) { double :event, reservations: reservations, messages: messages }
  describe '#call' do
    subject(:action) { instance.call }
    let(:reservation1) { double :reservation1 }
    let(:reservation2) { double :reservation2 }
    let(:reservations) { [reservation1, reservation2] }
    let(:messages) { double :messages, create: nil }
    before { allow(SendFinishedJob).to receive :perform_later }

    it { is_expected.to eq reservations.count }

    it 'creates messages entry' do
      action
      expect(messages).to have_received(:create).with category: :finished, scheduled_count: reservations.count
    end

    it 'sends mails in background' do
      action
      reservations.each do |reservation|
        expect(SendFinishedJob).to have_received(:perform_later).with(reservation)
      end
    end
  end
end
