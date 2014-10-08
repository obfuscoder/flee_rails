require 'rails_helper'

RSpec.describe "items/show", :type => :view do
  before(:each) do
    @item = assign(:item, Item.create!(
      :seller => nil,
      :description => "Description",
      :size => "Size",
      :price => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Size/)
    expect(rendered).to match(/9.99/)
  end
end
