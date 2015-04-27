require 'rails_helper'

RSpec.describe 'items/new' do
  before(:each) do
    assign(:item, FactoryGirl.build(:item))
  end

  it_behaves_like 'a standard view'

  it 'renders new item form' do
    render

    assert_select 'form[action=?][method=?]', items_path, 'post' do
      assert_select 'select#item_category_id[name=?]', 'item[category_id]'
      assert_select 'input#item_description[name=?]', 'item[description]'
      assert_select 'input#item_size[name=?]', 'item[size]'
      assert_select 'input#item_price[name=?]', 'item[price]'
    end
  end
end
