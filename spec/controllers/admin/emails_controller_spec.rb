# frozen_string_literal: true

require 'rails_helper'

module Admin
  RSpec.describe EmailsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { create :user }

    before { login_user user }

    describe 'GET index' do
      let(:seller) { create :seller }
      let!(:emails) { create_list :email, 5, seller: seller }

      before { get :index, params: { seller_id: seller.id } }

      describe '@seller' do
        subject { assigns :seller }

        it { is_expected.to eq seller }
      end

      describe '@emails' do
        subject { assigns :emails }

        it { is_expected.to all(satisfy { |e| emails.include? e }) }
      end

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status :ok }
        it { is_expected.to render_template :index }
      end
    end

    describe 'GET show' do
      let(:email) { create :email }

      before { get :show, params: { seller_id: email.seller.id, id: email.id } }

      describe '@email' do
        subject { assigns :email }

        it { is_expected.to eq email }
      end

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status :ok }
        it { is_expected.to render_template :show }
      end
    end

    describe 'GET emails' do
      let!(:active_seller) { create :seller }
      let!(:inactive_seller) { create :seller, active: false }
      let!(:event) { create :event_with_ongoing_reservation }
      let!(:reservation) { create :reservation, event: event, seller: active_seller }
      let!(:item) { create :item, reservation: reservation }
      let!(:notification) { create :notification, event: event, seller: inactive_seller }

      before do
        allow(Seller).to receive(:with_mailing).and_call_original
        allow(Event).to receive(:all).and_call_original
        get :emails
      end

      it 'calls proper scopes on event and seller' do
        expect(Seller).to have_received(:with_mailing).at_least(:once)
        expect(Event).to have_received(:all).at_least(:once)
      end

      describe 'response' do
        subject { response }

        it { is_expected.to render_template :emails }
        it { is_expected.to have_http_status :ok }
      end

      describe '@email' do
        subject { assigns :email }

        it { is_expected.to be_a CustomEmail }
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
        subject(:json) { assigns :json }

        it 'is a json string containing ids to sellers' do
          expect(json).to eq '{"all":[1,2],"active":[1],"inactive":[2],'\
                            '"events":{"1":{"reservation":[1],"notification":[2],"items":[1]}}}'
        end
      end
    end

    describe 'POST create' do
      let(:mail_subject) { 'subject' }
      let(:body) { 'body' }
      let(:seller) { create :seller }
      let(:params) { { custom_email: { subject: mail_subject, body: body, sellers: [seller.id] } } }

      before do
        allow(SellerMailer).to receive(:custom).and_return(double(deliver_later: true))
        post :create, params: params
      end

      it 'sends mail' do
        expect(SellerMailer).to have_received(:custom).with(seller, mail_subject, body)
      end
    end
  end
end
