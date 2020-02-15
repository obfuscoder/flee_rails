require 'rails_helper'

RSpec.describe SellersController do
  before { allow(SellerMailer).to receive(:registration).and_return(double(deliver_later: self)) }

  let(:mail) { double :mail, deliver_later: nil }

  describe 'GET new' do
    before { get :new }

    it 'assigns a new Seller as @seller' do
      expect(assigns(:seller)).to be_a_new Seller
    end

    it { expect(response).to render_template :new }
    it { expect(response).to have_http_status :ok }
  end

  describe 'POST create' do
    before { allow(SellerMailer).to receive(:registration).and_return mail }

    context 'with valid params' do
      subject(:action) { post :create, params: { seller: build(:seller).attributes.merge(accept_terms: '1') } }

      it 'increases the number of seller instances in the database' do
        expect { action }.to change(Seller, :count).by 1
      end

      describe '@seller' do
        subject { assigns :seller }

        before { action }

        it { is_expected.to eq Seller.last }
        it { is_expected.to be_persisted }
      end

      describe 'response' do
        subject { response }

        before { action }

        it { is_expected.to render_template :create }
        it { is_expected.to have_http_status :ok }
      end

      it 'sends activation email with correct parameters' do
        action
        expect(SellerMailer).to have_received(:registration) { |seller| expect(seller).to be_a Seller }
        expect(mail).to have_received(:deliver_later).with no_args
      end
    end

    context 'with invalid params' do
      subject(:action) { post :create, params: { seller: { name: nil } } }

      describe '@seller' do
        subject { assigns :seller }

        before { action }

        it { is_expected.to be_a_new Seller }
      end

      describe 'response' do
        subject { response }

        before { action }

        it { is_expected.to render_template :new }
        it { is_expected.to have_http_status :ok }
      end

      it 'does not send activation email' do
        action
        expect(SellerMailer).not_to have_received :registration
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
    let(:post_it) { post :resend_activation, params: { seller: { email: email } } }

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
        mail = double :mail, deliver_later: nil
        allow(SellerMailer).to receive(:registration).and_return mail
        post_it
        expect(SellerMailer).to have_received(:registration).with(seller)
        expect(mail).to have_received(:deliver_later).with no_args
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
        allow(SellerMailer).to receive :registration
        post_it
        expect(SellerMailer).not_to have_received :registration
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
        allow(SellerMailer).to receive :registration
        post_it
        expect(SellerMailer).not_to have_received :registration
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
        allow(SellerMailer).to receive :registration
        post_it
        expect(SellerMailer).not_to have_received :registration
      end
    end
  end

  describe 'GET login' do
    subject(:action) { get :login, params: { token: token } }

    let(:seller) { create :seller }

    context 'with valid token' do
      let(:token) { seller.token }

      it { is_expected.to redirect_to seller_path }

      it 'resets session' do
        session[:foo] = :bar
        expect { action }.to change { session[:foo] }.to nil
      end

      it 'stores seller id in session' do
        expect { action }.to change { session[:seller_id] }.to seller.id
      end

      context 'when seller was not active' do
        let(:seller) { create :seller, active: false }

        it 'activates seller' do
          expect { action }.to change { seller.reload.active }.to true
        end

        context 'with current event' do
          let!(:event) { create(:event) }

          it 'does not send invitation mail to seller' do
            allow(SellerMailer).to receive :invitation
            action
            expect(SellerMailer).not_to have_received :invitation
          end

          context 'when invitation has been sent already' do
            let!(:event) do
              create(:event).tap { |event| event.update messages: [create(:invitation_message, event: event)] }
            end

            it 'sends invitation mail to seller' do
              allow(SellerMailer).to receive(:invitation) { double deliver_later: true }
              action
              expect(SellerMailer).to have_received(:invitation) { double deliver_later: true }
            end

            context 'when event is not reservable by seller' do
              it 'does not send invitation mail to seller' do
                allow(SellerMailer).to receive(:invitation)
                allow_any_instance_of(Event).to receive(:reservable_by?).with(seller).and_return(false)
                action
                expect(SellerMailer).not_to have_received :invitation
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
    subject(:action) { get :show }

    let(:seller) { create :seller }

    context 'without valid seller session' do
      it { is_expected.to have_http_status :unauthorized }
    end

    context 'with valid seller session' do
      before { session[:seller_id] = seller.id }

      it { is_expected.to render_template :show }
      it { is_expected.to have_http_status :ok }

      describe '@seller' do
        subject { assigns :seller }

        before { action }

        it { is_expected.to eq seller }
      end

      describe '@events' do
        subject { assigns :events }

        let!(:event) { create :event_with_ongoing_reservation }

        before { action }

        it { is_expected.to include event }
      end

      describe '@events_with_support' do
        subject { assigns :events_with_support }

        let!(:event) { create :event_with_support }

        before { action }

        it { is_expected.to include event }
      end
    end
  end
end
