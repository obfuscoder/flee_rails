# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a mail body part' do
  it { is_expected.not_to match(/translation missing/) }
  it 'has expected contents' do
    expected_contents.each { |content| is_expected.to include content }
  end

  it { is_expected.not_to match(/\{\{.+\}\}/) }
end

RSpec.shared_examples 'a mail with headers' do
  its(:from) { is_expected.to eq [client.mail_address] }
  its(:class) { is_expected.to eq ActionMailer::MessageDelivery }
  its(:to) { is_expected.to eq [seller.email] }
  its(:subject) { is_expected.not_to match(/translation missing/) }
end

RSpec.shared_examples 'a mail multipart body' do
  it { is_expected.to be_multipart }
  its(:parts) { is_expected.to have(2).elements }

  describe 'text' do
    subject { body.parts.first.body }

    it_behaves_like 'a mail body part'
  end

  describe 'html' do
    subject { body.parts.last.body }

    it_behaves_like 'a mail body part'
  end
end

RSpec.shared_examples 'a mail with attachment' do
  it_behaves_like 'a mail with headers'

  describe 'body' do
    subject(:body) { mail.parts[1].body }

    it_behaves_like 'a mail multipart body'
  end
end

RSpec.shared_examples 'a mail' do
  it_behaves_like 'a mail with headers'

  describe 'body' do
    subject(:body) { mail.body }

    it_behaves_like 'a mail multipart body'
  end
end

RSpec.describe SellerMailer do
  let(:client) { Client.first }

  describe '#registration' do
    subject(:mail) { described_class.registration seller }

    let(:seller) { build :seller }
    let(:expected_contents) do
      [seller.first_name, seller.street, seller.zip_code, seller.city,
       seller.phone, seller.email, login_seller_url(seller.token, host: client.domain)]
    end

    it_behaves_like 'a mail'

    its(:subject) { is_expected.to eq 'Registrierungsbestätigung' }

    context 'when custom message template is defined' do
      let!(:custom_message_template) { create :registration_message_template, body: 'registration body' }
      let(:expected_contents) { [custom_message_template.body] }

      it_behaves_like 'a mail'

      its(:subject) { is_expected.to eq custom_message_template.subject }
    end
  end

  describe '#invitation' do
    subject(:mail) { described_class.invitation seller, event }

    let(:seller) { build :seller }
    let(:event) { build :event }
    let(:expected_contents) do
      [
        login_seller_url(seller.token, goto: :reserve, event: event, host: client.domain),
        event.max_reservations,
        event.name
      ]
    end

    it_behaves_like 'a mail'

    context 'when custom message template is defined' do
      let!(:custom_message_template) { create :invitation_message_template, body: 'invitation body' }
      let(:expected_contents) { [custom_message_template.body] }

      it_behaves_like 'a mail'

      its(:subject) { is_expected.to eq custom_message_template.subject }
    end
  end

  describe '#reservation' do
    subject(:mail) { described_class.reservation_closing reservation }

    let(:reservation) { build :reservation }
    let(:seller) { reservation.seller }
    let(:expected_contents) { [login_seller_url(seller.token, host: client.domain), reservation.number] }

    it_behaves_like 'a mail'
  end

  describe '#reservation_closing' do
    subject(:mail) { described_class.reservation_closing reservation }

    let(:reservation) { build :reservation }
    let(:seller) { reservation.seller }
    let(:expected_contents) { [login_seller_url(seller.token, host: client.domain), reservation.number] }

    it_behaves_like 'a mail'
  end

  describe '#reservation_closed' do
    subject(:mail) { described_class.reservation_closed reservation }

    let(:reservation) { build :reservation, items: items }
    let(:seller) { reservation.seller }
    let(:labels) { 'LABELS' }
    let(:items) { build_list :item, 5 }
    let(:expected_contents) { [login_seller_url(seller.token, host: client.domain), reservation.number] }

    before { allow(CreateLabelDocument).to receive(:new).with(client, items).and_return double(call: labels) }

    it_behaves_like 'a mail with attachment'

    it { expect(mail.parts[0].body).to eq labels }
  end

  describe '#finished' do
    subject(:mail) { described_class.finished reservation }

    let(:reservation) { build :reservation }
    let(:seller) { reservation.seller }
    let(:expected_contents) { [login_seller_url(seller.token, host: client.domain), reservation.number] }
    let(:receipt) { 'RECEIPT' }

    before { allow(CreateReceiptDocument).to receive(:new).with(reservation).and_return double(call: receipt) }

    it_behaves_like 'a mail with attachment'

    it { expect(mail.parts[0].body).to eq receipt }
  end

  describe '#custom' do
    subject(:mail) { described_class.custom seller, topic, content }

    let(:seller) { build :seller }
    let(:topic) { 'topic' }
    let(:content) { 'body' }
    let(:expected_contents) { [content] }

    it_behaves_like 'a mail'

    context 'when body contains a login link placeholder' do
      let(:content) { '{{login_link}}' }
      let(:expected_contents) { [login_seller_url(seller.token, host: client.domain)] }

      it_behaves_like 'a mail'
    end
  end
end
