require 'rails_helper'

module Admin
  RSpec.describe EventsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { FactoryGirl.create :user }
    before { login_user user }

    let(:event) { FactoryGirl.create :event, confirmed: false }

    describe 'PUT update' do
      let(:event_params) { { confirmed: true } }
      before { put :update, id: event.id, event: event_params }

      it 'updates confirmed' do
        expect(event.reload).to be_confirmed
      end

      it 'redirects to sellers path' do
        expect(response).to redirect_to admin_events_path
      end
    end
  end
end
