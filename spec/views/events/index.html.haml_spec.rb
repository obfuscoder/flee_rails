require 'rails_helper'

RSpec.describe "events/index", :type => :view do
  let(:events) { [FactoryGirl.create(:event), FactoryGirl.create(:event)] }
  before(:each) do
    assign(:events, events)
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => events.first.name, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
