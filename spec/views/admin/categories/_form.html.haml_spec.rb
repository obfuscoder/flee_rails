require 'rails_helper'

RSpec.describe 'admin/categories/_form' do
  before { assign :category, build(:category, max_items_per_seller: 4) }
  it_behaves_like 'a standard partial'

  it 'shows max items per seller input field' do
    render
    expect(rendered).to have_field 'max. Anzahl', with: '4'
  end
end
