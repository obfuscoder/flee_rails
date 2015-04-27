require 'rails_helper'

describe 'reserved_items/index', type: :view do
  let(:reserved_items) { [FactoryGirl.create(:reserved_item), FactoryGirl.create(:reserved_item)] }

  before do
    assign(:reserved_items, reserved_items)
  end

  it_behaves_like 'a standard view'

  it 'renders a list of reserved_items' do
    render
    assert_select 'tr>td', text: reserved_items.first.reservation, count: 1
    assert_select 'tr>td', text: reserved_items.last.reservation, count: 1
    assert_select 'tr>td', text: reserved_items.first.item, count: 2
    assert_select 'tr>td', text: reserved_items.first.number, count: 1
    assert_select 'tr>td', text: reserved_items.last.number, count: 1
    assert_select 'tr>td', text: reserved_items.first.code, count: 1
    assert_select 'tr>td', text: reserved_items.last.code, count: 1
  end
end
