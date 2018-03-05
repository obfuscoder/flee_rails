# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendReservationClosingJob do
  let(:reservation) { double :reservation }
  subject(:action) { described_class.perform_now reservation }
  let(:mail) { double deliver_now: nil }
  before do
    allow(SellerMailer).to receive(:reservation_closing).and_return mail
    action
  end

  it 'sends mail' do
    expect(SellerMailer).to have_received(:reservation_closing).with reservation
    expect(mail).to have_received :deliver_now
  end
end
