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

    expect(rendered).to have_css "form[action='#{event_reservation_item_path(event, reservation, item)}']"
    expect(rendered).to have_select 'item_category_id'
    expect(rendered).to have_field 'item_description'
    expect(rendered).to have_field 'item_size'
    expect(rendered).to have_field 'item_price'
  end
end
