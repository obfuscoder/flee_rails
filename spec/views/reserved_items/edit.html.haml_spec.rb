require 'rails_helper'

RSpec.describe "reserved_items/edit", :type => :view do
  before(:each) do
    @reserved_item = assign(:reserved_item, FactoryGirl.create(:reserved_item))
  end

  it "renders the edit reserved_item form" do
    render

    assert_select "form[action=?][method=?]", reserved_item_path(@reserved_item), "post" do
      assert_select "select#reserved_item_reservation_id[name=?]", "reserved_item[reservation_id]"
      assert_select "select#reserved_item_item_id[name=?]", "reserved_item[item_id]"
      assert_select "input#reserved_item_number[name=?]", "reserved_item[number]"
      assert_select "input#reserved_item_code[name=?]", "reserved_item[code]"
    end
  end
end
