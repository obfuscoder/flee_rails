require 'rails_helper'

RSpec.describe "sellers/new", :type => :view do
  before(:each) do
    assign(:seller, Seller.new(
      :first_name => "MyString",
      :last_name => "MyString",
      :street => "MyString",
      :zip_code => "MyString",
      :city => "MyString",
      :email => "MyString",
      :phone => "MyString"
    ))
  end

  it "renders new seller form" do
    render

    assert_select "form[action=?][method=?]", sellers_path, "post" do

      assert_select "input#seller_first_name[name=?]", "seller[first_name]"

      assert_select "input#seller_last_name[name=?]", "seller[last_name]"

      assert_select "input#seller_street[name=?]", "seller[street]"

      assert_select "input#seller_zip_code[name=?]", "seller[zip_code]"

      assert_select "input#seller_city[name=?]", "seller[city]"

      assert_select "input#seller_email[name=?]", "seller[email]"

      assert_select "input#seller_phone[name=?]", "seller[phone]"
    end
  end
end
