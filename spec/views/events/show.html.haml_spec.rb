require 'rails_helper'

RSpec.describe "events/show", :type => :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event, details: "Details", max_items_per_seller: 50, confirmed: true ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@event.name}/)
    expect(rendered).to match(/#{@event.details}/)
    expect(rendered).to match(/#{@event.max_sellers}/)
    expect(rendered).to match(/#{@event.max_items_per_seller}/)
    expect(rendered).to match(/#{@event.confirmed}/)
  end
end
