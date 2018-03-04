# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendInvitation do
  subject(:instance) { described_class.new(event) }
  let(:event) { double :event, messages: messages }
  describe '#call' do
    subject(:action) { instance.call }
    let(:mail) { double :mail, deliver_later: nil }
    let(:query) { double :query, invitable_sellers: sellers }
    let(:seller1) { double :seller1 }
    let(:seller2) { double :seller2 }
    let(:sellers) { [seller1, seller2] }
    let(:messages) { double :messages, create: nil }
    before do
      allow(InvitationQuery).to receive(:new).with(event).and_return query
      allow(SellerMailer).to receive(:invitation).and_return mail
    end

    it { is_expected.to eq sellers.count }

    it 'creates messages entry' do
      action
      expect(messages).to have_received(:create).with(category: :invitation, count: sellers.count)
    end

    it 'sends mails in background' do
      action
      sellers.each do |s|
        expect(SellerMailer).to have_received(:invitation).with(s, event)
      end
      expect(mail).to have_received(:deliver_later).exactly(sellers.count).times
    end
  end
end
