require 'rails_helper'

RSpec.describe "events/show", :type => :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :name => "Name",
      :details => "MyText",
      :max_sellers => 1,
      :max_items_per_seller => 2,
      :confirmed => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
  end
end
