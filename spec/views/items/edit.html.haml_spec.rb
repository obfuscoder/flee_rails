# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'items/edit' do
  let(:item) { create :item }
  let(:reservation) { item.reservation }
  let(:event) { reservation.event }
  before do
    assign :item, item
    assign :event, event
    assign :reservation, reservation
  end

  it_behaves_like 'a standard view'

  it 'renders the edit item form' do
    render

    assert_select +'form[action=?][method=?]', event_reservation_item_path(event, reservation, item), 'post' do
      assert_select +'select#item_category_id[name=?]', 'item[category_id]'
      assert_select +'input#item_description[name=?]', 'item[description]'
      assert_select +'input#item_size[name=?]', 'item[size]'
      assert_select +'input#item_price[name=?]', 'item[price]'
    end
  end
end
