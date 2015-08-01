require 'rails_helper'

module Admin
  RSpec.describe EmailsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { FactoryGirl.create :user }
    before { login_user user }

    describe 'GET emails' do
      let!(:active_seller) { FactoryGirl.create :seller, active: true }
      let!(:inactive_seller) { FactoryGirl.create :seller, active: false }
      let!(:event) { FactoryGirl.create :event_with_ongoing_reservation }
      let!(:reservation) { FactoryGirl.create :reservation, event: event, seller: active_seller }
      let!(:item) { FactoryGirl.create :item, reservation: reservation }
      let!(:notification) { FactoryGirl.create :notification, event: event, seller: inactive_seller }
      before do
        expect(Seller).to receive(:with_mailing).at_least(:once).and_call_original
        expect(Event).to receive(:all).at_least(:once).and_call_original
        get :emails
      end

      describe 'response' do
        subject { response }
        it { is_expected.to render_template :emails }
        it { is_expected.to have_http_status :ok }
      end

      describe '@email' do
        subject { assigns :email }
        it { is_expected.to be_a_new Email }
      end

      describe '@sellers' do
        subject { assigns(:sellers).to_a }
        it { is_expected.to have(2).items }
      end

      describe '@events' do
        subject { assigns :events }
        it { is_expected.to have(1).item }
      end

      describe '@json' do
        subject { assigns :json }
        it do
          is_expected.to eq '{"all":[1,2],"active":[1],"inactive":[2],"events":{"1":{"reservation":[1],' \
                            '"notification":[2],"items":[1]}}}'
        end
      end
    end

    describe 'POST create' do
      let(:subject) { 'subject' }
      let(:body) { 'body' }
      let(:from) { Settings.brands.default.mail.from }
      let(:seller) { FactoryGirl.create :seller }
      let(:params) { { email: { subject: subject, body: body, sellers: [seller.id] } } }
      before do
        allow(SellerMailer).to receive(:custom).and_return(double deliver_later: true)
        post :create, params
      end

      it 'sends mail' do
        expect(SellerMailer).to have_received(:custom).with(seller, subject, body, from: from, host: 'test.host')
      end
    end
  end
end