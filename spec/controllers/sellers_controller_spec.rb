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
      before do
        post :create, model => FactoryGirl.build(:seller)
      end

      it "sends activation email"
    end

    context "with invalid params" do
      before do
        post :create, model => {name: nil}
      end

      it "does not send activation email"
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
    before do
      post :resend_activation, seller: { email: email }
    end

    context "with known email" do
      let(:email) do
        seller = FactoryGirl.create(:seller)
        seller.email
      end

      it { expect(response).to render_template("activation_resent") }
      it { expect(response).to have_http_status :ok }
      it "sends activation email"
    end

    context "with unknown email" do
      let(:email) { 'unknown@email.com' }

      it { expect(assigns(:seller)).to be_a_new(Seller) }
      it { expect(response).to render_template("resend_activation") }
      it { expect(response).to have_http_status :ok }
      it "sets appropriate alert message" do
        expect(flash[:alert]).to_not be_nil
      end
    end

    context "with invalid email" do
      let(:email) { 'invalid@email.' }

      it { expect(assigns(:seller)).to be_a_new(Seller) }
      it { expect(response).to render_template("resend_activation") }
      it { expect(response).to have_http_status :ok }
      it "sets appropriate alert message" do
        expect(flash[:alert]).to_not be_nil
      end
    end
  end
end
