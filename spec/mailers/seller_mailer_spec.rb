require 'rails_helper'

RSpec.shared_examples 'a mail body part' do
  it { is_expected.not_to match(/translation missing/) }
  it 'has expected contents' do
    expected_contents.each { |content| expect(subject).to include content }
  end
end

RSpec.shared_examples 'a mail with headers' do
  its(:from) { is_expected.to eq [from] }
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
  let(:from) { 'info@flohmarkthelfer.de' }
  let(:host) { 'www.example.com' }
  describe '#registration' do
    let(:seller) { build :seller }
    let(:expected_contents) do
      [seller.first_name, seller.street, seller.zip_code, seller.city,
       seller.phone, seller.email, login_seller_url(seller.token, host: host)]
    end
    subject(:mail) { SellerMailer.registration seller, host: host, from: from }

    it_behaves_like 'a mail'
  end

  describe '#reservation' do
    let(:reservation) { build :reservation }
    let(:seller) { reservation.seller }
    let(:expected_contents) { [login_seller_url(seller.token, host: host), reservation.number] }
    subject(:mail) { SellerMailer.reservation reservation, host: host, from: from }

    it_behaves_like 'a mail'
  end

  describe '#finished' do
    let(:reservation) { build :reservation }
    let(:seller) { reservation.seller }
    let(:expected_contents) { [login_seller_url(seller.token, host: host), reservation.number] }
    let(:receipt) { 'RECEIPT' }
    subject(:mail) { SellerMailer.finished reservation, receipt, host: host, from: from }

    it_behaves_like 'a mail with attachment'

    it { expect(mail.parts[0].body).to eq receipt }
  end

  describe '#custom' do
    let(:seller) { build :seller }
    let(:topic) { 'topic' }
    let(:content) { 'body' }
    let(:expected_contents) { [content] }
    subject(:mail) { SellerMailer.custom seller, topic, content, host: host, from: from }

    it_behaves_like 'a mail'

    context 'when body contains a login link placeholder' do
      let(:content) { '{{login_link}}' }
      let(:expected_contents) { [login_seller_url(seller.token, host: host)] }

      it_behaves_like 'a mail'
    end
  end
end
