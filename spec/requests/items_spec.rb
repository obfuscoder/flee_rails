require 'rails_helper'

RSpec.describe "Items" do
  describe "GET /items" do
    context "with seller signed in" do
      let(:seller) { FactoryGirl.create :seller }
      before do
        get login_seller_path seller.token
      end
      it "shows items of logged in seller" do
        get items_path
        expect(response).to have_http_status(200)
      end
    end
  end
end
