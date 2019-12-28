require 'rails_helper'

RSpec.describe 'pages/terms.html.haml' do
  it_behaves_like 'a standard view'

  it 'contains terms' do
    render
    expect(rendered).to have_content 'In Kommission genommen werden'
  end
end
