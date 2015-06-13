require 'rails_helper'

RSpec.feature 'Reservations' do
  let(:seller) { FactoryGirl.create :seller }
  let(:event) { FactoryGirl.create :event }

  scenario 'seller tries to get reservation for event' do
    visit reserve_seller_url(seller.token, event.id)
    expect(page).to have_content 'Die Reservierung ist nocht nicht freigeschaltet.'
  end
end
