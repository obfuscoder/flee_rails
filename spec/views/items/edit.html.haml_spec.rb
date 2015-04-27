require 'rails_helper'

RSpec.describe 'items/edit' do
  before(:each) do
    @item = assign(:item, FactoryGirl.create(:item))
  end

  it_behaves_like 'a standard view'

  it 'renders the edit item form' do
    render

    assert_select 'form[action=?][method=?]', item_path(@item), 'post' do
      assert_select 'select#item_category_id[name=?]', 'item[category_id]'
      assert_select 'input#item_description[name=?]', 'item[description]'
      assert_select 'input#item_size[name=?]', 'item[size]'
      assert_select 'input#item_price[name=?]', 'item[price]'
    end
  end
end
