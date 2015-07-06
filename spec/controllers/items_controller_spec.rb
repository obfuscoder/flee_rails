require 'rails_helper'

RSpec.describe ItemsController do
  let(:item) { FactoryGirl.create :item }
  let(:event) { item.reservation.event }
  let(:seller) { item.reservation.seller }
  before do
    session[:seller_id] = seller.id
  end

  def update_action
    post :update, event_id: event.id, id: item.id, item: { description: item.description }
  end

  context 'with code' do
    let(:item) { FactoryGirl.create :item_with_code }

    it 'does not allow editing item with label' do
      expect(get :edit, event_id: event.id, id: item.id).to redirect_to event_items_path(event)
    end

    it 'does not allow updating item with label' do
      expect(update_action).to redirect_to event_items_path(event)
    end

    it 'does not allow deleting item with label' do
      expect(delete :destroy, event_id: event.id, id: item.id).to redirect_to event_items_path(event)
    end
  end

  context 'with other seller signed in' do
    let(:seller) { FactoryGirl.create :seller }
    it 'does not allow editing/updating/deleting items which are not owned by the current seller' do
      expect(get :edit, event_id: event.id, id: item.id).to have_http_status :unauthorized
      expect(update_action).to have_http_status :unauthorized
      expect(delete :destroy, event_id: event.id, id: item.id).to have_http_status :unauthorized
    end
  end
end
