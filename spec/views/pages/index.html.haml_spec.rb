require 'rails_helper'

RSpec.describe 'pages/index.html.haml' do
  let(:event) { double client: client, name: 'event name', confirmed?: false, shopping_periods: [shopping_period] }
  let(:shopping_period) { double min: 1.day.from_now, max: 1.day.from_now + 2.hours }
  let(:client) { double name: 'client name', url: 'http://client1.flohmarkthelfer.de/' }

  before do
    assign :clients, [client]
    assign :events, [event]
    render
  end

  it_behaves_like 'a standard partial'

  it 'lists and links to all clients' do
    expect(rendered).to have_link client.name, href: client.url
  end

  it 'links to events of all clients' do
    expect(rendered).to have_link event.name, href: event.client.url
  end
end
