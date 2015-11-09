require 'rails_helper'

RSpec.describe 'admin/events/show' do
  let(:event) { create :event }
  before { assign :event, event }
  it_behaves_like 'a standard view'

  context 'with direct event' do
    let(:Event) { create :direct_event }
    it_behaves_like 'a standard view'
  end

  it 'shows token' do
    render
    expect(rendered).to have_content event.token
  end
end
