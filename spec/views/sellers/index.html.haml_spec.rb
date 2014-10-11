require 'rails_helper'

RSpec.describe "sellers/index" do
  let(:sellers) { [FactoryGirl.create(:seller), FactoryGirl.create(:seller)] }

  before(:each) do
    assign(:sellers, sellers)
  end

  it "renders a list of sellers" do
    render
    assert_select "tr>td", text: sellers.first.first_name, count: 2
    assert_select "tr>td", text: sellers.first.last_name, count: 2
    assert_select "tr>td", text: sellers.first.email, count: 1
    assert_select "tr>td", text: sellers.last.email, count: 1
  end
end
