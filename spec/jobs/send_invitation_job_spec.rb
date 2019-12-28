require 'rails_helper'

RSpec.describe SendInvitationJob do
  subject(:action) { described_class.perform_now seller, event }

  let(:event) { double :event, messages: messages }
  let(:seller) { double :seller }
  let(:mail) { double deliver_now: nil }
  let(:messages) { double :messages }
  let(:message) { double :message, sent: nil }

  before do
    allow(messages).to receive(:find_by!).with(category: :invitation).and_return message
    allow(SellerMailer).to receive(:invitation).and_return mail
    action
  end

  it 'sends mail' do
    expect(SellerMailer).to have_received(:invitation).with seller, event
    expect(mail).to have_received :deliver_now
  end

  it 'increases sent_count in for associated message' do
    expect(message).to have_received(:sent)
  end
end
