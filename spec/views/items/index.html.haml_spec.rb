require 'rails_helper'

RSpec.describe "items/index" do
  let(:category) { FactoryGirl.create(:category) }
  let(:items) { [FactoryGirl.create(:item, size: "Size"), FactoryGirl.create(:item, size: "Size")] }
  before(:each) do
    assign(:items, items)
  end

  it "renders a list of items" do
    render
    assert_select "tr>td", text: items.first.seller.to_s, count: 2
    assert_select "tr>td", text: items.first.category.to_s, count: 1
    assert_select "tr>td", text: items.last.category.to_s, count: 1
    assert_select "tr>td", text: items.first.description, count: 2
    assert_select "tr>td", text: items.first.size, count: 2
    assert_select "tr>td", text: items.first.price.to_s, count: 2
  end
end
