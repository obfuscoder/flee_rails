# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendReservationClosingJob do
  subject(:action) { described_class.perform_now reservation }
  let(:event) { double :event, messages: messages }
  let(:reservation) { double :reservation, event: event }
  let(:mail) { double deliver_now: nil }
  let(:messages) { double :messages }
  let(:message) { double :message, sent: nil }
  before do
    allow(messages).to receive(:find_by!).with(category: :reservation_closing).and_return message
    allow(SellerMailer).to receive(:reservation_closing).and_return mail
    action
  end

  it 'sends mail' do
    expect(SellerMailer).to have_received(:reservation_closing).with reservation
    expect(mail).to have_received :deliver_now
  end

  it 'increases sent_count in for associated message' do
    expect(message).to have_received(:sent)
  end
end
