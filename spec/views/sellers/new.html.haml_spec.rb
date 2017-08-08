# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sellers/new' do
  before(:each) do
    assign(:seller, build(:seller))
  end

  it_behaves_like 'a standard view'

  it 'renders new seller form' do
    render
    expect(rendered).to have_css "form[action='#{seller_path}'][method=post]"
    expect(rendered).to have_field 'seller_first_name'
    expect(rendered).to have_field 'seller_last_name'
    expect(rendered).to have_field 'seller_street'
    expect(rendered).to have_field 'seller_zip_code'
    expect(rendered).to have_field 'seller_city'
    expect(rendered).to have_field 'seller_email'
    expect(rendered).to have_field 'seller_phone'
    expect(rendered).to have_css '#terms'
    expect(rendered).to have_css '#privacy'
  end
end
