require 'rails_helper'

RSpec.describe 'Sellers' do
  describe 'GET /seller/new' do
    it 'works! (now write some real specs)' do
      get new_seller_path
      expect(response).to have_http_status(200)
    end
  end
end
