# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController do
  describe 'POST create' do
    context 'with seller signed in' do
      let(:seller) { create :seller }
      before do
        session[:seller_id] = seller.id
      end
      context 'with valid event' do
        let!(:event) { create :event }
        context 'with already existing notification' do
          let!(:notification) { Notification.create event: event, seller: seller }
          it 'does not create another notification' do
            expect { post :create, event_id: event.id }.to_not change { Notification.count }
          end
          it 'redirects to seller view' do
            expect(post(:create, event_id: event.id)).to redirect_to seller_path
          end
        end
        context 'with non existing notification' do
          it 'creates notification' do
            expect(Notification.find_by(event: event, seller: seller)).to be_nil
            post :create, event_id: event.id
            expect(Notification.find_by(event: event, seller: seller)).not_to be_nil
          end
          it 'redirects to seller view' do
            expect(post(:create, event_id: event.id)).to redirect_to seller_path
          end
        end
      end
      context 'with invalid event' do
        let(:event_id) { 9999 }
        it 'throws error' do
          expect { post :create, event_id: event_id }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'with out seller signed in' do
      let!(:event) { create :event }
      before { session[:seller_id] = nil }
      it 'shows unauthorized error' do
        expect(post(:create, event_id: event.id)).to have_http_status :unauthorized
      end
    end
  end

  describe 'DELETE destroy' do
    let(:seller) { create :seller }
    before { session[:seller_id] = seller.id }

    let!(:event) { create :event }
    let(:delete_action) { delete :destroy, event_id: event.id }
    let!(:notification) { Notification.create event: event, seller: seller }

    it 'deletes notification' do
      expect { delete_action }.to change { Notification.count }.by(-1)
    end

    it 'redirects to sellers view' do
      expect(delete_action).to redirect_to seller_path
    end
  end
end
