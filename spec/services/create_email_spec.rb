# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateEmail do
  subject(:action) { described_class.new(message).call sent }

  before { allow(Client).to receive(:find_by).and_return found_client }

  let(:message) do
    double :message, from: [from], to: [seller.email], subject: mail_subject,
                     message_id: message_id, text?: true, decoded: body
  end
  let(:found_client) { client }
  let(:seller) { build :seller }
  let(:client) { double :client, sellers: sellers }
  let(:sellers) { double :sellers, where: [seller] }
  let(:mail_subject) { 'subject' }
  let(:body) { 'body' }
  let(:sent) { true }
  let(:from) { 'info@example.com' }
  let(:message_id) { 'message id' }

  it { is_expected.to be_persisted.and be_an Email }
  it do
    is_expected.to have_attributes body: body,
                                   subject: mail_subject,
                                   from: from,
                                   to: seller.email,
                                   message_id: message_id,
                                   seller: seller,
                                   sent: sent
  end

  it 'performs client lookup based on mail address' do
    action
    expect(Client).to have_received(:find_by).with(mail_address: from)
  end

  it 'performs proper seller lookup' do
    action
    expect(sellers).to have_received(:where).with(email: seller.email)
  end

  context 'when from address is client key related' do
    let(:from) { 'demo@test.host' }
    let(:found_client) { nil }

    it 'performs client lookup based on key' do
      action
      expect(Client).to have_received(:find_by).with(key: 'demo')
    end
  end
end
