require 'rails_helper'
require 'support/shared_examples_for_controllers'

RSpec.describe SellersController do
  it_behaves_like "a standard controller" do
    let(:valid_update_attributes) { { first_name: "Newfirst", last_name: "Newlast" } }
    let(:virtual_attributes) { { accept_terms: "1" } }
    let(:invalid_update_attributes) { { first_name: nil, last_name: nil } }
  end

  describe "POST create" do
    context "with valid params" do
      it "sends activation email" do
        mail = double("mail")
        expect(SellerMailer).to receive(:registration).with(no_args).and_return(mail)
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
end
