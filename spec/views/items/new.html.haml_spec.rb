require 'rails_helper'

RSpec.describe 'items/new' do
  let!(:event) { assign :event, item.reservation.event }
  let(:item) { assign :item, create(:item) }
  let!(:reservation) { assign :reservation, item.reservation }

  before { render }

  it_behaves_like 'a standard view'

  it 'renders the form' do
    expect(view).to render_template partial: 'items/_form'
  end
end
