# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SellersController do
  before { allow(SellerMailer).to receive(:registration).and_return(double(deliver_now: self)) }

  describe 'GET new' do
    before { get :new }

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

      before { call_post }

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
      before { post :create, seller: { name: nil } }

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
        expect(mail).to receive(:deliver_now).with no_args
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
    let(:post_it) { post :resend_activation, seller: { email: email } }
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
        mail = double :mail
        expect(SellerMailer).to receive(:registration).with(seller).and_return mail
        expect(mail).to receive(:deliver_now).with no_args
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
      it 'sets @seller with error info' do
        post_it
        expect(assigns(:seller).errors.messages).not_to be_empty
      end
      it 'does not send email' do
        expect(SellerMailer).not_to receive :registration
        post_it
      end
    end

    context 'with email associated with other client' do
      let!(:client) { create :client }
      let!(:seller) { create :seller, client: client }
      let(:email) { seller.email }

      it 'renders template resend_activation' do
        post_it
        expect(response).to render_template :resend_activation
      end
      it 'responds with :ok' do
        post_it
        expect(response).to have_http_status :ok
      end
      it 'sets @seller with error info' do
        post_it
        expect(assigns(:seller).errors.messages).not_to be_empty
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

      it 'sets @seller with error info' do
        post_it
        expect(assigns(:seller).errors.messages).not_to be_empty
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
              expect(SellerMailer).to receive(:invitation) { double deliver_now: true }
              subject
            end

            context 'when event is not reservable by seller' do
              it 'does not send invitation mail to seller' do
                expect(SellerMailer).not_to receive :invitation
                allow_any_instance_of(Event).to receive(:reservable_by?).with(seller).and_return(false)
                subject
              end
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
    subject(:action) { get :show }

    context 'without valid seller session' do
      it { is_expected.to have_http_status :unauthorized }
    end

    context 'with valid seller session' do
      before { session[:seller_id] = seller.id }
      it { is_expected.to render_template :show }
      it { is_expected.to have_http_status :ok }

      describe '@seller' do
        before { action }
        subject { assigns :seller }
        it { is_expected.to eq seller }
      end

      describe '@events' do
        let!(:event) { create :event_with_ongoing_reservation }
        before { action }
        subject { assigns :events }
        it { is_expected.to include event }
      end

      describe '@events_with_support' do
        let!(:event) { create :event_with_support }
        before { action }
        subject { assigns :events_with_support }
        it { is_expected.to include event }
      end
    end
  end
end
