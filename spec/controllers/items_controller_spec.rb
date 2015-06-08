require 'rails_helper'

RSpec.describe ItemsController do
  let(:label) { FactoryGirl.create :label }
  let(:seller) { label.item.seller }
  before do
    session[:seller_id] = seller.id
  end

  def update_action
    post :update, id: label.item.id, item: { description: label.item.description }
  end

  it 'does not allow editing item with label' do
    expect(get :edit, id: label.item.id).to redirect_to items_path
  end

  it 'does not allow updating item with label' do
    expect(update_action).to redirect_to items_path
  end

  it 'does not allow deleting item with label' do
    expect(delete :destroy, id: label.item.id).to redirect_to items_path
  end

  context 'with other seller signed in' do
    let(:seller) { FactoryGirl.create :seller }
    it 'does not allow editing/updating/deleting items which are not owned by the current seller' do
      expect(get :edit, id: label.item.id).to have_http_status :unauthorized
      expect(update_action).to have_http_status :unauthorized
      expect(delete :destroy, id: label.item.id).to have_http_status :unauthorized
    end
  end
end
