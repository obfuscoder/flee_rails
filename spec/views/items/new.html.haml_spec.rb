# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'items/new' do
  let!(:event) { assign :event, item.reservation.event }
  let(:item) { assign :item, build(:item) }
  let!(:reservation) { assign :reservation, item.reservation }

  it_behaves_like 'a standard view'

  it 'renders new item form' do
    render

    expect(rendered).to have_select 'item_category_id'
    expect(rendered).to have_field 'item_description'
    expect(rendered).to have_field 'item_size'
    expect(rendered).to have_field 'item_price'
  end
end
