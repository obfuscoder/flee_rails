require 'rails_helper'

RSpec.describe "events/edit" do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event))
  end

  it_behaves_like "a standard view"

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
