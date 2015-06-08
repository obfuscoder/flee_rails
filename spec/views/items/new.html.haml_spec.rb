require 'rails_helper'

RSpec.describe 'items/new' do
  before do
    item = assign :item, FactoryGirl.build(:item)
    @event = assign :event, item.reservation.event
  end

  it_behaves_like 'a standard view'

  it 'renders new item form' do
    render

    assert_select 'form[action=?][method=?]', event_items_path(@event), 'post' do
      assert_select 'select#item_category_id[name=?]', 'item[category_id]'
      assert_select 'input#item_description[name=?]', 'item[description]'
      assert_select 'input#item_size[name=?]', 'item[size]'
      assert_select 'input#item_price[name=?]', 'item[price]'
    end
  end
end
