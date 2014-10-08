require 'rails_helper'

RSpec.describe "reserved_items/show", :type => :view do
  before(:each) do
    @reserved_item = assign(:reserved_item, ReservedItem.create!(
      :reservation => nil,
      :item => nil,
      :number => 1,
      :code => "Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Code/)
  end
end
