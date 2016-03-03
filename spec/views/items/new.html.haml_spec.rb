require 'rails_helper'

RSpec.describe 'items/new' do
  before do
    item = assign :item, build(:item)
    @event = assign :event, item.reservation.event
    @reservation = assign :reservation, item.reservation
  end

  it_behaves_like 'a standard view'

  it 'renders new item form' do
    render

    assert_select 'form[action=?][method=?]', event_reservation_items_path(@event, @reservation), 'post' do
      assert_select 'select#item_category_id[name=?]', 'item[category_id]'
      assert_select 'input#item_description[name=?]', 'item[description]'
      assert_select 'input#item_size[name=?]', 'item[size]'
      assert_select 'input#item_price[name=?]', 'item[price]'
    end
  end
end
