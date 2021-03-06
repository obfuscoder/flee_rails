require 'rails_helper'

RSpec.describe 'admin/pages/home' do
  it_behaves_like 'a standard view'

  it 'provides link to cashier system software' do
    render
    expect(rendered).to have_link 'Kassensystem (Windows)'
    expect(rendered).to have_link 'Mobiles Kassensystem (Android)'
  end
end
