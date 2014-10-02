require 'rails_helper'

RSpec.describe "events/new", :type => :view do
  before(:each) do
    assign(:event, Event.new(
      :name => "MyString",
      :details => "MyText",
      :max_sellers => 1,
      :max_items_per_seller => 1,
      :confirmed => false
    ))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input#event_name[name=?]", "event[name]"

      assert_select "textarea#event_details[name=?]", "event[details]"

      assert_select "input#event_max_sellers[name=?]", "event[max_sellers]"

      assert_select "input#event_max_items_per_seller[name=?]", "event[max_items_per_seller]"

      assert_select "input#event_confirmed[name=?]", "event[confirmed]"
    end
  end
end
