require 'rails_helper'

RSpec.describe "reserved_items/index", :type => :view do
  before(:each) do
    assign(:reserved_items, [
      ReservedItem.create!(
        :reservation => nil,
        :item => nil,
        :number => 1,
        :code => "Code"
      ),
      ReservedItem.create!(
        :reservation => nil,
        :item => nil,
        :number => 1,
        :code => "Code"
      )
    ])
  end

  it "renders a list of reserved_items" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
  end
end
