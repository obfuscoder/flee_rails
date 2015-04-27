require 'rails_helper'

RSpec.describe 'reserved_items/show' do
  before(:each) do
    @reserved_item = assign(:reserved_item, FactoryGirl.create(:reserved_item))
  end

  it_behaves_like 'a standard view'

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/#{@reserved_item.reservation.to_s}/)
    expect(rendered).to match(/#{@reserved_item.item.to_s}/)
    expect(rendered).to match(/#{@reserved_item.number}/)
    expect(rendered).to match(/#{@reserved_item.code}/)
  end
end
