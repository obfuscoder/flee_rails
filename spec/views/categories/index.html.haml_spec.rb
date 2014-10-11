require 'rails_helper'

RSpec.describe "categories/index" do
  let (:categories) { [FactoryGirl.create(:category), FactoryGirl.create(:category)] }
  before(:each) do
    assign(:categories, categories)
  end

  it "renders a list of categories" do
    render
    assert_select "tr>td", text: categories.first.name, count: 1
    assert_select "tr>td", text: categories.last.name, count: 1
  end
end
