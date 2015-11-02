require 'rails_helper'

RSpec.describe 'pages/terms.html.haml' do
  it_behaves_like 'a standard view'

  it 'contains terms' do
    expect(Settings.brands.default).to receive(:terms).and_return('MYTERMS')
    render
    expect(rendered).to have_content 'MYTERMS'
  end
end
