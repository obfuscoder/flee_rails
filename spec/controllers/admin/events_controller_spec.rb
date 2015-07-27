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
        let(:shopping_time1) { FactoryGirl.attributes_for :shopping_period }
        let(:shopping_time2) { FactoryGirl.attributes_for :shopping_period, min: 2.weeks.from_now }
        let(:event_params) { { shopping_periods_attributes: [shopping_time1, shopping_time2] } }
        it 'persists shopping times' do
          event.reload
          expect(event.shopping_periods.first.min.to_i).to eq shopping_time1[:min].to_i
          expect(event.shopping_periods.first.max.to_i).to eq shopping_time1[:max].to_i
          expect(event.shopping_periods.last.min.to_i).to eq shopping_time2[:min].to_i
          expect(event.shopping_periods.last.max.to_i).to eq shopping_time2[:max].to_i
        end

        context 'when removing a shopping period' do
          before { expect(event.shopping_periods).not_to be_empty }
          let(:event_params) { { shopping_periods_attributes: [id: event.shopping_periods.first.id, _destroy: true] } }

          it 'removes shopping period' do
            expect(event.reload.shopping_periods).to be_empty
          end
        end
      end
    end
  end
end
