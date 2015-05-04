require 'rails_helper'

RSpec.shared_examples 'a mail body part' do
  it { is_expected.not_to match(/translation missing/) }
  it { is_expected.to match(/#{seller.first_name}/) }
  it { is_expected.to match(/#{seller.street}/) }
  it { is_expected.to match(/#{seller.zip_code}/) }
  it { is_expected.to match(/#{seller.city}/) }
  it { is_expected.to match(/#{seller.phone}/) }
  it { is_expected.to match(/#{seller.email}/) }
  it { is_expected.to match(/#{seller.token}/) }
end

RSpec.describe SellerMailer do
  describe '#registration' do
    let(:seller) { FactoryGirl.build :seller }
    subject(:mail) { SellerMailer.registration seller }

    its(:from) { is_expected.to eq ['info@flohmarkt-koenigsbach.de'] }
    its(:class) { is_expected.to eq ActionMailer::MessageDelivery }
    its(:to) { is_expected.to eq [seller.email] }
    its(:subject) { is_expected.not_to match(/translation missing/) }

    describe 'body' do
      subject(:body) { mail.body }

      it { is_expected.to be_multipart }
      its(:parts) { is_expected.to have(2).elements }

      describe 'text' do
        subject { body.parts.first.to_s }
        it_behaves_like 'a mail body part'
      end

      describe 'html' do
        subject { body.parts.last.to_s }
        it_behaves_like 'a mail body part'
      end
    end
  end
end
