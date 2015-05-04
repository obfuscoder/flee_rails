require 'rails_helper'

RSpec.describe NotificationsController do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/events/1/reservation').to route_to('reservations#create', event_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/events/1/reservation').to route_to('reservations#destroy', event_id: '1')
    end
  end
end
