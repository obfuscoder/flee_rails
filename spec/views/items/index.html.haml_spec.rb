require 'rails_helper'

RSpec.describe "items/index", :type => :view do
  before(:each) do
    assign(:items, [
      Item.create!(
        :seller => nil,
        :description => "Description",
        :size => "Size",
        :price => "9.99"
      ),
      Item.create!(
        :seller => nil,
        :description => "Description",
        :size => "Size",
        :price => "9.99"
      )
    ])
  end

  it "renders a list of items" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Size".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
