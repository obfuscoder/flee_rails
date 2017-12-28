# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pages/index.html.haml' do
  it_behaves_like 'a standard partial'

  let(:clients) { [double(name: 'client name', url: 'http://demo.flohmarkthelfer.de/')] }

  before do
    assign :clients, clients
    render
  end

  it 'lists and links to all clients' do
    expect(rendered).to have_link clients.first.name, href: clients.first.url
  end
end
