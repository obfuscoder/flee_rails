# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SellersController do
  before do
    allow(SellerMailer).to receive(:registration).and_return(double(deliver_later: self))
  end

  describe 'GET new' do
    before do
      get :new
    end

    it 'assigns a new Seller as @seller' do
      expect(assigns(:seller)).to be_a_new Seller
    end

    it { expect(response).to render_template :new }
    it { expect(response).to have_http_status :ok }
  end

  describe 'POST create' do
    context 'with valid params' do
      def call_post
        post :create, seller: build(:seller).attributes.merge(accept_terms: '1')
      end

      before do
        call_post
      end

      it 'increases the number of seller instances in the database' do
        expect { call_post }.to change { Seller.count }.by 1
      end

      it 'assigns the new instance to @seller' do
        expect(assigns(:seller)).to eq Seller.last
      end
      it { expect(assigns(:seller)).to be_persisted }
      it { expect(response).to render_template :create }
      it { expect(response).to have_http_status :ok }
    end

    context 'with invalid params' do
      before do
        post :create, seller: { name: nil }
      end

      it 'assigns the not yet persisted instance to @seller' do
        expect(assigns(:seller)).to be_a_new Seller
      end
      it { expect(response).to render_template :new }
      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'sends activation email with correct parameters' do
        mail = double :mail
        expect(SellerMailer).to receive :registration do |seller|
          expect(seller).to be_a Seller
          mail
        end
        expect(mail).to receive(:deliver_later).with no_args
        post :create, seller: attributes_for(:seller)
      end
    end

    context 'with invalid params' do
      it 'does not send activation email' do
        expect(SellerMailer).not_to receive :registration
        post :create, seller: { name: nil }
      end
    end
  end

  describe 'GET resend_activation' do
    before do
      get :resend_activation
    end

    it 'assigns a new Seller as @seller' do
      expect(assigns(:seller)).to be_a_new Seller
    end

    it { expect(response).to render_template :resend_activation }
    it { expect(response).to have_http_status :ok }
  end

  describe 'POST resend_activation' do
    def post_it
      post :resend_activation, seller: { email: email }
    end
    context 'with known email' do
      let(:seller) { create :seller }
      let(:email) { seller.email }

      it 'renders activation_resent template' do
        post_it
        expect(response).to render_template :activation_resent
      end

      it 'responds with :ok' do
        post_it
        expect(response).to have_http_status :ok
      end

      it 'sends registration email' do
        mail = double('mail')
        expect(SellerMailer).to receive(:registration).with(seller, hash_including(host: request.host)).and_return mail
        expect(mail).to receive(:deliver_later).with no_args
        post_it
      end
    end

    context 'with unknown email' do
      let(:email) { 'unknown@email.com' }

      it 'renders template resend_activation' do
        post_it
        expect(response).to render_template :resend_activation
      end
      it 'responds with :ok' do
        post_it
        expect(response).to have_http_status :ok
      end
      it 'sets appropriate alert message' do
        post_it
        expect(flash[:alert]).to_not be_nil
      end
      it 'does not send email' do
        expect(SellerMailer).not_to receive :registration
        post_it
      end
    end

    context 'with invalid email' do
      let(:email) { 'invalid@email.' }

      it 'responds with :ok' do
        post_it
        expect(response).to have_http_status :ok
      end

      it 'sets appropriate alert message' do
        post_it
        expect(flash[:alert]).to_not be_nil
      end

      it 'does not send email' do
        expect(SellerMailer).not_to receive :registration
        post_it
      end
    end
  end

  describe 'GET login' do
    let(:seller) { create :seller }

    subject { get :login, token: token }

    context 'with valid token' do
      let(:token) { seller.token }
      it { is_expected.to redirect_to seller_path }
      it 'resets session' do
        session[:foo] = :bar
        expect { subject }.to change { session[:foo] }.to nil
      end

      it 'stores seller id in session' do
        expect { subject }.to change { session[:seller_id] }.to seller.id
      end

      context 'when seller was not active' do
        let(:seller) { create :seller, active: false }

        it 'activates seller' do
          expect { subject }.to change { seller.reload.active }.to true
        end

        context 'with current event' do
          let!(:event) { create(:event) }
          it 'does not send invitation mail to seller' do
            expect(SellerMailer).not_to receive :invitation
            subject
          end

          context 'when invitation has been sent already' do
            let!(:event) do
              create(:event).tap { |event| event.update messages: [create(:invitation_message, event: event)] }
            end
            it 'sends invitation mail to seller' do
              expect(SellerMailer).to receive(:invitation) { double deliver_later: true }
              subject
            end
          end
        end
      end
    end

    context 'with unknown token' do
      let(:token) { 'unknown_token' }
      it { is_expected.to have_http_status :unauthorized }
    end
  end

  describe 'GET show' do
    let(:seller) { create :seller }
    subject { get :show }

    context 'without valid seller session' do
      it { is_expected.to have_http_status :unauthorized }
    end

    context 'with valid seller session' do
      before do
        session[:seller_id] = seller.id
      end
      it { is_expected.to render_template :show }
      it { is_expected.to have_http_status :ok }
      it 'assigns the seller from the session to @seller' do
        subject
        expect(assigns(:seller)).to eq seller
      end
      it 'assigns events within reservation time to @events' do
        event1 = create :event_with_ongoing_reservation
        event2 = create :event_with_ongoing_reservation
        subject
        expect(assigns(:events)).to include event1, event2
      end
    end
  end
end
