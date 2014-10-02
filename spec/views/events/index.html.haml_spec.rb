require 'rails_helper'

RSpec.describe "events/index", :type => :view do
  before(:each) do
    assign(:events, [
      Event.create!(
        :name => "Name",
        :details => "MyText",
        :max_sellers => 1,
        :max_items_per_seller => 2,
        :confirmed => false
      ),
      Event.create!(
        :name => "Name",
        :details => "MyText",
        :max_sellers => 1,
        :max_items_per_seller => 2,
        :confirmed => false
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
