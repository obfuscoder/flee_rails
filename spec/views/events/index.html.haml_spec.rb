require 'rails_helper'

RSpec.describe "events/index" do
  let(:events) { [FactoryGirl.create(:event), FactoryGirl.create(:event)] }
  before(:each) do
    assign(:events, events)
    render
  end

  it_behaves_like "a standard view"

  it "renders a list of events" do
    assert_select "tr>td", text: events.first.name, count: 1
    assert_select "tr>td", text: events.last.name, count: 1
    assert_select "tr>td", text: 1.to_s, count: 2
  end
end
