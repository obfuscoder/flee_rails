require 'rails_helper'

RSpec.describe "items/show" do
  before(:each) do
    @item = assign(:item, FactoryGirl.create(:item))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@item.seller.to_s}/)
    expect(rendered).to match(/#{@item.category}/)
    expect(rendered).to match(/#{@item.description}/)
    expect(rendered).to match(/#{@item.size}/)
    expect(rendered).to match(/#{@item.price}/)
  end
end
