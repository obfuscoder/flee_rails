require 'rails_helper'

RSpec.describe 'admin/events/_form' do
  before { assign :event, build(:event) }
  it_behaves_like 'a standard partial'

  it 'shows confirmed option' do
    render
    expect(rendered).to have_field 'Termin steht fest'
  end

  it 'shows confirmed option' do
    render
    expect(rendered).to have_field 'Reservierungen pro Verkäufer'
  end
end
