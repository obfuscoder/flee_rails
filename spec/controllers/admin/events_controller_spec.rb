require 'rails_helper'

module Admin
  RSpec.describe EventsController do
    include Sorcery::TestHelpers::Rails::Controller
    let(:user) { FactoryGirl.create :user }
    before { login_user user }

    let(:event) { FactoryGirl.create :event, confirmed: false }

    describe 'GET new' do
      before { get :new }
      describe 'response' do
        subject { response }
        it { is_expected.to render_template :new }
        it { is_expected.to have_http_status :ok }
      end
      describe '@event' do
        subject { assigns :event }
        it { is_expected.to be_a_new Event }
      end
    end

    describe 'PUT update' do
      let(:event_params) { { confirmed: true } }
      before { put :update, id: event.id, event: event_params }

      it 'updates confirmed' do
        expect(event.reload).to be_confirmed
      end

      it 'redirects to sellers path' do
        expect(response).to redirect_to admin_events_path
      end

      context 'when updating shopping times' do
        let(:shopping_times) { { id: event.shopping_periods.first.id, min: 1.day.ago, max: 8.hours.ago } }
        let(:event_params) { { shopping_periods_attributes: [shopping_times] } }
        it 'persists shopping times' do
          event.reload
          expect(event.shopping_periods.first.min.to_i).to eq shopping_times[:min].to_i
          expect(event.shopping_periods.first.max.to_i).to eq shopping_times[:max].to_i
        end
      end
    end
  end
end
