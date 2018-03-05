# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendInvitationJob do
  let(:event) { double :event }
  let(:seller) { double :seller }
  subject(:action) { described_class.perform_now seller, event }
  let(:mail) { double deliver_now: nil }
  before do
    allow(SellerMailer).to receive(:invitation).and_return mail
    action
  end

  it 'sends mail' do
    expect(SellerMailer).to have_received(:invitation).with seller, event
    expect(mail).to have_received :deliver_now
  end
end
