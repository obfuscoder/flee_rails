require 'rails_helper'

RSpec.describe "reservations/index", :type => :view do
  let(:reservations) { [FactoryGirl.create(:reservation), FactoryGirl.create(:reservation)] }
  before(:each) do
    assign(:reservations, reservations)
  end

  it "renders a list of reservations" do
    render
    assert_select "tr>td", :text => "Firstname Lastname", :count => 2
    assert_select "tr>td", :text => "Eventname", :count => 2
    assert_select "tr>td", :text => reservations.first.number.to_s, :count => 1
    assert_select "tr>td", :text => reservations.last.number.to_s, :count => 1
  end
end
