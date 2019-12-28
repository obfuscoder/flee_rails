require 'rails_helper'

RSpec.describe SendInvitationMails do
  subject(:instance) { described_class.new event }

  let(:event) { double :event, messages: messages }

  describe '#call' do
    subject(:action) { instance.call }

    let(:query) { double :query, invitable_sellers: sellers }
    let(:seller1) { double :seller1 }
    let(:seller2) { double :seller2 }
    let(:sellers) { [seller1, seller2] }
    let(:messages) { double :messages, create: nil }

    before do
      allow(InvitationQuery).to receive(:new).with(event).and_return query
      allow(SendInvitationJob).to receive :perform_later
    end

    it { is_expected.to eq sellers.count }

    it 'creates messages entry' do
      action
      expect(messages).to have_received(:create).with category: :invitation, scheduled_count: sellers.count
    end

    it 'sends mails in background' do
      action
      sellers.each do |seller|
        expect(SendInvitationJob).to have_received(:perform_later).with seller, event
      end
    end
  end
end
