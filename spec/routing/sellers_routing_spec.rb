require "rails_helper"

RSpec.describe SellersController do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/sellers").to route_to("sellers#index")
    end

    it "routes to #new" do
      expect(get: "/sellers/new").to route_to("sellers#new")
    end

    it "routes to #show" do
      expect(get: "/sellers/1").to route_to("sellers#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/sellers/1/edit").to route_to("sellers#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/sellers").to route_to("sellers#create")
    end

    it "routes to #update" do
      expect(put: "/sellers/1").to route_to("sellers#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/sellers/1").to route_to("sellers#destroy", id: "1")
    end

    it "routes to #resend_activation" do
      expect(get: "/sellers/resend_activation").to route_to("sellers#resend_activation")
    end

  end
end
