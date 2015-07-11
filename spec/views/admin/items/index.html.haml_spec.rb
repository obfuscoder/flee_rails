require 'rails_helper'

RSpec.describe 'admin/items/index' do
  before do
    reservation = assign :reservation, FactoryGirl.create(:reservation)
    assign :items, [FactoryGirl.create(:item, reservation: reservation)]
  end

  it_behaves_like 'a standard view'

  it 'renders price in Euro' do
    render
    expect(rendered).to have_content '1,90 €'
  end
end
