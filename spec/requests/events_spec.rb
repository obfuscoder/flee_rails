require 'rails_helper'

RSpec.describe "Events" do
  describe "GET /events" do
    it "works! (now write some real specs)" do
      get events_path
      expect(response).to have_http_status(200)
    end
  end
end
