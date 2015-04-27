require 'rails_helper'

RSpec.describe 'events/show' do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event, details: 'Details', max_items_per_seller: 50, confirmed: true))
  end

  it_behaves_like 'a standard view'

  it 'renders attributes' do
    render
    expect(rendered).to match(/#{@event.name}/)
    expect(rendered).to match(/#{@event.details}/)
    expect(rendered).to match(/#{@event.max_sellers}/)
    expect(rendered).to match(/#{@event.max_items_per_seller}/)
    expect(rendered).to match(/#{@event.confirmed}/)
  end
end
