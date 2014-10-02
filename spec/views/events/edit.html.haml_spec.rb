require 'rails_helper'

RSpec.describe "events/edit", :type => :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :name => "MyString",
      :details => "MyText",
      :max_sellers => 1,
      :max_items_per_seller => 1,
      :confirmed => false
    ))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input#event_name[name=?]", "event[name]"

      assert_select "textarea#event_details[name=?]", "event[details]"

      assert_select "input#event_max_sellers[name=?]", "event[max_sellers]"

      assert_select "input#event_max_items_per_seller[name=?]", "event[max_items_per_seller]"

      assert_select "input#event_confirmed[name=?]", "event[confirmed]"
    end
  end
end
