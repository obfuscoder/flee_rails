require 'rails_helper'

RSpec.describe 'items/index' do
  let(:seller) { FactoryGirl.create :seller }
  let(:reservation) { FactoryGirl.create :reservation, seller: seller }
  before do
    assign :items, FactoryGirl.create_list(:item, 50, reservation: reservation).paginate(page: 2)
    assign :seller, seller
    assign :event, reservation.event
    allow_any_instance_of(ApplicationHelper).to receive(:sort_link_to)
  end

  it_behaves_like 'a standard view'

  before { render }

  it 'shows prices in €' do
    expect(rendered).to have_content '1,90 €'
  end

  it 'shows pagination' do
    expect(rendered).to have_link 'Zurück'
    expect(rendered).to have_text 'Weiter'
  end
end
