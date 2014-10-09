require 'rails_helper'

RSpec.describe "items/new", :type => :view do
  before(:each) do
    assign(:item, Item.new(
      seller: FactoryGirl.create(:seller),
      category: FactoryGirl.create(:category),
      description: "MyString",
      size: "MyString",
      price: "9.99"
    ))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do
      assert_select "select#item_seller_id[name=?]", "item[seller_id]"
      assert_select "select#item_category_id[name=?]", "item[category_id]"
      assert_select "input#item_description[name=?]", "item[description]"
      assert_select "input#item_size[name=?]", "item[size]"
      assert_select "input#item_price[name=?]", "item[price]"
    end
  end
end
