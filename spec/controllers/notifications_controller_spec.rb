require 'rails_helper'

RSpec.describe NotificationsController do
  describe 'POST create' do
    context 'with seller signed in' do
      let(:seller) { FactoryGirl.create :seller }
      before do
        session[:seller_id] = seller.id
      end
      context 'with valid event' do
        let!(:event) { FactoryGirl.create :event }
        context 'with already existing notification' do
          let!(:notification) { Notification.create event: event, seller: seller }
          it 'does not create another notification' do
            expect { post :create, event_id: event.id }.to_not change { Notification.count }
          end
          it 'redirects to seller view' do
            expect(post :create, event_id: event.id).to redirect_to seller_path
          end
        end
        context 'with nonexisting notification' do
          it 'creates notification' do
            expect(Notification.find_by event: event, seller: seller).to be_nil
            post :create, event_id: event.id
            expect(Notification.find_by event: event, seller: seller).not_to be_nil
          end
          it 'redirects to seller view' do
            expect(post :create, event_id: event.id).to redirect_to seller_path
          end
        end
      end
      context 'with invalid event' do
        let(:event_id) { 9999 }
        it 'redirects to seller view' do
          expect(post :create, event_id: event_id).to redirect_to seller_path
        end
      end
    end

    context 'with out seller signed in' do
      it 'shows unauthorized error'
    end
  end

  describe 'DELETE destroy' do
    let(:seller) { FactoryGirl.create :seller }

    before do
      session[:seller_id] = seller.id
    end

    let!(:event) { FactoryGirl.create :event }
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
