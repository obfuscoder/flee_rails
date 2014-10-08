require "rails_helper"

RSpec.describe ReservedItemsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/reserved_items").to route_to("reserved_items#index")
    end

    it "routes to #new" do
      expect(:get => "/reserved_items/new").to route_to("reserved_items#new")
    end

    it "routes to #show" do
      expect(:get => "/reserved_items/1").to route_to("reserved_items#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/reserved_items/1/edit").to route_to("reserved_items#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/reserved_items").to route_to("reserved_items#create")
    end

    it "routes to #update" do
      expect(:put => "/reserved_items/1").to route_to("reserved_items#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/reserved_items/1").to route_to("reserved_items#destroy", :id => "1")
    end

  end
end
