# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sellers/create' do
  before(:each) do
    @seller = assign(:seller, create(:seller))
  end

  it_behaves_like 'a standard view'

  it 'renders seller information' do
    render
    expect(rendered).to match(/#{@seller.first_name}/)
    expect(rendered).to match(/#{@seller.last_name}/)
    expect(rendered).to match(/#{@seller.street}/)
    expect(rendered).to match(/#{@seller.zip_code}/)
    expect(rendered).to match(/#{@seller.city}/)
    expect(rendered).to match(/#{@seller.email}/)
    expect(rendered).to have_content @seller.phone
  end
end
