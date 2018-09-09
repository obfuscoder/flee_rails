# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateEmail do
  subject { described_class.new(message).call sent }

  before { allow(Seller).to receive(:find_by).with(email: seller.email).and_return seller }

  let(:message) do
    double :message, from: [from], to: [seller.email], subject: mail_subject,
                     message_id: message_id, text?: true, decoded: body
  end
  let(:seller) { build :seller }
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
end
