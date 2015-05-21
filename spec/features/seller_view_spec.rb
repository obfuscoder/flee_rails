require 'rails_helper'

RSpec.feature 'Seller view area' do
  let(:seller) { FactoryGirl.create :seller }
  let(:preparation) {}
  background do
    preparation
    login
  end

  def login
    visit login_seller_path(seller.token)
  end

  scenario 'private home page is shown after login' do
    expect(page).to have_content 'Verkäuferbereich'
  end

  scenario 'shows seller address information' do
    expect(page).to have_content seller.first_name
    expect(page).to have_content seller.street
  end

  context 'with event' do
    let(:event) { FactoryGirl.create :event }
    let(:preparation) { event }

    scenario 'can make a reservation' do
      click_link 'einen Verkäuferplatz reservieren', href: event_reservation_path(event)
      expect(page).to have_content 'Die Reservierung war erfolgreich. Ihre Reservierungsnummer lautet 1.'
      expect(page).to have_content 'Sie haben die Reservierungsnummer 1'
      expect(page).to have_link 'geben Sie Ihre Reservierung wieder frei', href: event_reservation_path(event)
    end

    context 'with reservation limit reached' do
      let(:preparation) { FactoryGirl.create :reservation, event: event }

      scenario 'cannot make a reservation' do
        expect(page).to have_content 'Leider sind alle Plätze bereits vergeben.'
        expect(page).not_to have_link 'einen Verkäuferplatz reservieren', href: event_reservation_path(event)
      end

      scenario 'can activate notification' do
        click_link 'Warteliste', href: event_notification_path(event)
        expect(page).to have_content 'Sie wurden auf der Warteliste eingetragen.'
        expect(page).to have_content 'Sie stehen auf der Warteliste'
      end
    end

    context 'with reservation' do
      let(:preparation) { FactoryGirl.create :reservation, event: event, seller: seller }

      scenario 'can free reservation' do
        click_link 'geben Sie Ihre Reservierung wieder frei', href: event_reservation_path(event)
        expect(page).to have_content 'Ihre Reservierung wurde freigegeben.'
        expect(page).to have_link 'einen Verkäuferplatz reservieren', href: event_reservation_path(event)
      end
    end
  end
end
