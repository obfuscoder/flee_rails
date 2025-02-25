require 'rails_helper'
require_relative 'shared_examples_for_mailers'

RSpec.shared_examples 'a seller mail' do
  let(:to) { seller.email }

  it_behaves_like 'a mail'

  describe 'unsubscribe header' do
    subject { mail.header['List-Unsubscribe'].value }

    it { is_expected.to start_with '<http://demo.test.host/sellers/login/token' }
    it { is_expected.to end_with '?goto=unsubscribe>' }
  end
end

RSpec.shared_examples 'a seller mail with attachment' do
  let(:to) { seller.email }

  it_behaves_like 'a mail with attachment'
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

    it_behaves_like 'a seller mail'

    its(:subject) { is_expected.to eq 'Registrierungsbestätigung' }

    context 'when custom message template is defined' do
      let!(:custom_message_template) { create :registration_message_template, body: 'registration body' }
      let(:expected_contents) { [custom_message_template.body] }

      it_behaves_like 'a seller mail'

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

    it_behaves_like 'a seller mail'

    context 'when custom message template is defined' do
      let!(:custom_message_template) { create :invitation_message_template, body: 'invitation body' }
      let(:expected_contents) { [custom_message_template.body] }

      it_behaves_like 'a seller mail'

      its(:subject) { is_expected.to eq custom_message_template.subject }
    end
  end

  describe '#reservation' do
    subject(:mail) { described_class.reservation reservation }

    let(:reservation) { build :reservation }
    let(:seller) { reservation.seller }
    let(:expected_contents) { [login_seller_url(seller.token, host: client.domain), reservation.number] }

    it_behaves_like 'a seller mail'
  end

  describe '#reservation_closing' do
    subject(:mail) { described_class.reservation_closing reservation }

    let(:reservation) { build :reservation }
    let(:seller) { reservation.seller }
    let(:expected_contents) { [login_seller_url(seller.token, host: client.domain), reservation.number] }

    it_behaves_like 'a seller mail'
  end

  describe '#reservation_closed' do
    subject(:mail) { described_class.reservation_closed reservation }

    let(:reservation) { build :reservation, items: items }
    let(:seller) { reservation.seller }
    let(:labels) { 'LABELS' }
    let(:items) { build_list :item, 5 }
    let(:expected_contents) { [login_seller_url(seller.token, host: client.domain), reservation.number] }

    before { allow(CreateLabelDocument).to receive(:new).with(client, items).and_return double(call: labels) }

    it_behaves_like 'a seller mail with attachment'

    it { expect(mail.parts.second.body.raw_source).to eq labels }
  end

  describe '#finished' do
    subject(:mail) { described_class.finished reservation }

    let(:reservation) { build :reservation }
    let(:seller) { reservation.seller }
    let(:expected_contents) { [login_seller_url(seller.token, host: client.domain), reservation.number] }
    let(:receipt) { 'RECEIPT' }

    before { allow(CreateReceiptDocument).to receive(:new).with(reservation).and_return double(call: receipt) }

    it_behaves_like 'a seller mail with attachment'

    it { expect(mail.parts.second.body).to eq receipt }
  end

  describe '#custom' do
    subject(:mail) { described_class.custom seller, topic, content }

    let(:seller) { build :seller }
    let(:topic) { 'topic' }
    let(:content) { 'body' }
    let(:expected_contents) { [content] }

    it_behaves_like 'a seller mail'

    ['{{login_link}}', '{{ login_link }}', '{{ login_url }}'].each do |placeholder|
      context "when body contains the login url placeholder #{placeholder}" do
        let(:content) { placeholder }
        let(:expected_contents) { [login_seller_url(seller.token, host: client.domain)] }

        it_behaves_like 'a seller mail'
      end
    end

    context 'when seller specific placeholders are used' do
      let(:properties) { %w[name first_name last_name street zip_code city phone email] }
      let(:content) { properties.map { |property| "{{ seller_#{property} }}" }.join '\n' }
      let(:expected_contents) { properties.map { |property| seller.send property } }

      it_behaves_like 'a seller mail'
    end
  end
end
