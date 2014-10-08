require 'rails_helper'

RSpec.describe "items/edit", :type => :view do
  before(:each) do
    @item = assign(:item, Item.create!(
      :seller => nil,
      :description => "MyString",
      :size => "MyString",
      :price => "9.99"
    ))
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(@item), "post" do

      assert_select "input#item_seller_id[name=?]", "item[seller_id]"

      assert_select "input#item_description[name=?]", "item[description]"

      assert_select "input#item_size[name=?]", "item[size]"

      assert_select "input#item_price[name=?]", "item[price]"
    end
  end
end
