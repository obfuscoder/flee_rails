require 'rails_helper'

RSpec.describe "reserved_items/new", :type => :view do
  before(:each) do
    assign(:reserved_item, ReservedItem.new(
      :reservation => nil,
      :item => nil,
      :number => 1,
      :code => "MyString"
    ))
  end

  it "renders new reserved_item form" do
    render

    assert_select "form[action=?][method=?]", reserved_items_path, "post" do
      assert_select "select#reserved_item_reservation_id[name=?]", "reserved_item[reservation_id]"
      assert_select "select#reserved_item_item_id[name=?]", "reserved_item[item_id]"
      assert_select "input#reserved_item_number[name=?]", "reserved_item[number]"
      assert_select "input#reserved_item_code[name=?]", "reserved_item[code]"
    end
  end
end
