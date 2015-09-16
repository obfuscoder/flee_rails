require 'rails_helper'

RSpec.describe 'items/index' do
  let(:event) { FactoryGirl.create :event_with_ongoing_reservation }
  let(:seller) { FactoryGirl.create :seller }
  let(:reservation) { FactoryGirl.create :reservation, seller: seller, event: event }
  before do
    assign :items, FactoryGirl.create_list(:item, 50, reservation: reservation).paginate(page: 2)
    assign :seller, seller
    assign :event, reservation.event
    allow_any_instance_of(ApplicationHelper).to receive(:sort_link_to) { |_, cls, attribute| "#{cls}.#{attribute}" }
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

  it 'does not show donation column' do
    expect(rendered).not_to have_text 'Item.donation'
  end

  context 'when donation is enabled for the event' do
    let(:event) { FactoryGirl.create :event_with_ongoing_reservation, donation_of_unsold_items_enabled: true }
    it 'shows donation column' do
      expect(rendered).to have_text 'Item.donation'
    end
  end
end
