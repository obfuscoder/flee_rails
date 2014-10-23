require 'rails_helper'
require 'support/shared_examples_for_controllers'

RSpec.describe SellersController do
  before do
    allow(SellerMailer).to receive(:registration).and_return(double deliver: self)
  end

  describe "GET new" do
    before do
      get :new
    end

    it "assigns a new Seller as @seller" do
      expect(assigns(:seller)).to be_a_new(Seller)
    end

    it { expect(response).to render_template("new") }
    it { expect(response).to have_http_status :ok }
  end

  describe "POST create" do
    context "with valid params" do
      def call_post
        post :create, seller: FactoryGirl.build(:seller).attributes.merge({accept_terms: "1"})
      end

      before do
        call_post
      end

      it "increases the number of seller instances in the database" do
        expect { call_post }.to change{Seller.count}.by(1)
      end

      it "assigns the new instance to @seller" do
        expect(assigns(:seller)).to eq(Seller.last)
      end
      it { expect(assigns(:seller)).to be_persisted }
      it { expect(response).to render_template "create" }
      it { expect(response).to have_http_status :ok }
    end

    context "with invalid params" do
      before do
        post :create, seller: {name: nil}
      end

      it "assigns the not yet persisted instance to @seller" do
        expect(assigns(:seller)).to be_a_new(Seller)
      end
      it { expect(response).to render_template("new") }
      it { expect(response).to have_http_status :ok }
    end
  end

  describe "POST create" do
    context "with valid params" do
      it "sends activation email with correct parameters" do
        mail = double("mail")
        expect(SellerMailer).to receive(:registration) do |seller, login_url|
          expect(seller).to be_a Seller
          expect(login_url).to match /#{seller.token}/
          mail
        end
        expect(mail).to receive(:deliver).with(no_args)
        post :create, seller: FactoryGirl.attributes_for(:seller)
      end
    end

    context "with invalid params" do
      it "does not send activation email" do
        expect(SellerMailer).not_to receive(:registration)
        post :create, seller: {name: nil}
      end
    end
  end

  describe "GET resend_activation" do
    before do
      get :resend_activation
    end

    it "assigns a new Seller as @seller" do
      expect(assigns(:seller)).to be_a_new(Seller)
    end

    it { expect(response).to render_template("resend_activation") }
    it { expect(response).to have_http_status :ok }
  end

  describe "POST resend_activation" do
    def post_it
      post :resend_activation, seller: { email: email }
    end
    context "with known email" do
      let(:email) do
        seller = FactoryGirl.create(:seller)
        seller.email
      end

      it "renders activation_resent template" do
        post_it
        expect(response).to render_template("activation_resent")
      end

      it "responds with :ok" do
        post_it
        expect(response).to have_http_status :ok
      end

      it "sends activation email" do
        mail = double("mail")
        expect(SellerMailer).to receive(:registration).with(no_args).and_return(mail)
        expect(mail).to receive(:deliver).with(no_args)
        post_it
      end
    end

    context "with unknown email" do
      let(:email) { 'unknown@email.com' }

      it "assigns a new Seller as @seller" do
        post_it
        expect(assigns(:seller)).to be_a_new(Seller)
      end
      it "renders template resend_activation" do
        post_it
        expect(response).to render_template("resend_activation")
      end
      it "responds with :ok" do
        post_it
        expect(response).to have_http_status :ok
      end
      it "sets appropriate alert message" do
        post_it
        expect(flash[:alert]).to_not be_nil
      end
      it "does not send email" do
        expect(SellerMailer).not_to receive(:registration)
        post_it
      end
    end

    context "with invalid email" do
      let(:email) { 'invalid@email.' }

      it "assigns a new Seller as @seller" do
        post_it
        expect(assigns(:seller)).to be_a_new(Seller)
      end

      it "renders template resend_activation" do
        post_it
        expect(response).to render_template("resend_activation")
      end

      it "responds with :ok" do
        post_it
        expect(response).to have_http_status :ok
      end

      it "sets appropriate alert message" do
        post_it
        expect(flash[:alert]).to_not be_nil
      end

      it "does not send email" do
        expect(SellerMailer).not_to receive(:registration)
        post_it
      end
    end
  end

  describe "GET login" do
    let(:seller) { FactoryGirl.create(:seller) }

    subject { get :login, token: token }

    context "with valid token" do
      let(:token) { seller.token }
      it { is_expected.to redirect_to seller_path }
      it "resets session"
      it "stores seller id in session"
    end

    context "with invalid token" do
      let(:token) { "invalid_token" }
      it "should redirect to 401"
    end
  end
end
