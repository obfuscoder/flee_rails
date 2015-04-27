require 'rails_helper'

RSpec.describe SellersController do
  describe 'routing' do

    it 'routes to #new' do
      expect(get: '/seller/new').to route_to('sellers#new')
    end

    it 'routes to #show' do
      expect(get: '/seller').to route_to('sellers#show')
    end

    it 'routes to #edit' do
      expect(get: '/seller/edit').to route_to('sellers#edit')
    end

    it 'routes to #create' do
      expect(post: '/seller').to route_to('sellers#create')
    end

    it 'routes to #update' do
      expect(put: '/seller').to route_to('sellers#update')
    end

    it 'routes to #destroy' do
      expect(delete: '/seller').to route_to('sellers#destroy')
    end

    it 'routes to #resend_activation' do
      expect(get: '/seller/resend_activation').to route_to('sellers#resend_activation')
      expect(post: '/seller/resend_activation').to route_to('sellers#resend_activation')
    end

    it 'routes to login' do
      expect(get: '/sellers/login/12345').to route_to('sellers#login', token: '12345')
    end
  end
end
