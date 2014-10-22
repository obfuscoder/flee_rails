require "rails_helper"

RSpec.shared_examples "a mail body part" do
  it { should_not match /translation missing/ }
  it { should match /#{seller.first_name}/ }
  it { should match /#{seller.last_name}/ }
  it { should match /#{seller.street}/ }
  it { should match /#{seller.zip_code}/ }
  it { should match /#{seller.city}/ }
  it { should match /#{seller.phone}/ }
  it { should match /#{seller.email}/ }
  it { should match /#{login_url}/ }
end

RSpec.describe SellerMailer do
  describe "#registration" do
    let(:seller) { FactoryGirl.build :seller }
    let(:login_url) { "http://login/1234" }
    subject(:mail) { SellerMailer.registration seller, login_url }

    its(:from) { should eq ['info@flohmarkt-koenigsbach.de'] }
    its(:class) { should eq Mail::Message }
    its(:to) { should eq [seller.email] }
    its(:subject) { should_not match /translation missing/ }

    describe "body" do
      subject(:body) { mail.body }

      it { is_expected.to be_multipart }
      its(:parts) { should have(2).elements }

      describe "text" do
        subject { body.parts.first.to_s }
        it_behaves_like "a mail body part"
      end

      describe "html" do
        subject { body.parts.last.to_s }
        it_behaves_like "a mail body part"
      end
    end
  end
end
