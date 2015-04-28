require 'rails_helper'

RSpec.feature 'Seller view area' do
  let(:seller) { FactoryGirl.create :seller }
  def login
    visit login_seller_path(seller.token)
  end

  scenario 'private home page is shown after login' do
    login
    expect(page).to have_content 'Verkäuferbereich'
  end

  scenario 'shows seller address information' do
    login
    expect(page).to have_content seller.first_name
    expect(page).to have_content seller.street
  end

  feature 'reservations' do
    let!(:event) { FactoryGirl.create :event }
    scenario 'make a reservation' do
      login
      click_link 'hier', href: event_reservation_path(event)
    end
  end
end
