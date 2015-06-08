require 'rails_helper'

RSpec.describe 'items/index' do
  before do
    items = assign :items, [FactoryGirl.create(:item)]
    assign :seller, FactoryGirl.create(:seller)
    assign :event, items.first.reservation.event
  end

  it_behaves_like 'a standard view'
end
