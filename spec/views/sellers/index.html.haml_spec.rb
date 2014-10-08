require 'rails_helper'

RSpec.describe "sellers/index", :type => :view do
  before(:each) do
    assign(:sellers, [
      Seller.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :street => "Street",
        :zip_code => "Zip Code",
        :city => "City",
        :email => "Email",
        :phone => "Phone"
      ),
      Seller.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :street => "Street",
        :zip_code => "Zip Code",
        :city => "City",
        :email => "Email",
        :phone => "Phone"
      )
    ])
  end

  it "renders a list of sellers" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Street".to_s, :count => 2
    assert_select "tr>td", :text => "Zip Code".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
  end
end
