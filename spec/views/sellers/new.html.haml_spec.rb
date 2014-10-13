require 'rails_helper'

RSpec.describe "sellers/new" do
  before(:each) do
    assign(:seller, FactoryGirl.build(:seller))
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
      assert_select "input#seller_accept_terms[name=?]", "seller[accept_terms]"
      assert_select ".seller_accept_terms>label>a[data-target='#terms']"
      assert_select ".seller_accept_terms>label>a[data-target='#privacy']"
    end
    assert_select "#terms"
    assert_select "#privacy"
  end
end
