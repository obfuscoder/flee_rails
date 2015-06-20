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
    let(:event) { FactoryGirl.create :event_with_ongoing_reservation }
    let(:preparation) { event }

    scenario 'can make a reservation' do
      click_link 'einen Verkäuferplatz reservieren', href: event_reservation_path(event)
      expect(page).to have_content 'Die Reservierung war erfolgreich. Ihre Reservierungsnummer lautet 1.'
      expect(page).to have_content 'Sie haben die Reservierungsnummer 1'
      expect(page).to have_link 'geben Sie Ihre Reservierung wieder frei', href: event_reservation_path(event)
    end

    context 'when reservation period is not yet reached' do
      let(:event) { FactoryGirl.create :event_with_ongoing_reservation, reservation_start: 1.hour.from_now }
      scenario 'reservation is not possible' do
        expect(page).not_to have_link 'einen Verkäuferplatz reservieren', href: event_reservation_path(event)
      end
    end

    context 'when reservation period has passed' do
      let(:event) { FactoryGirl.create :event_with_ongoing_reservation, reservation_end: 1.hour.ago }
      scenario 'reservation is not possible' do
        expect(page).not_to have_link 'einen Verkäuferplatz reservieren', href: event_reservation_path(event)
      end
    end

    context 'with reservation limit reached' do
      let(:reservation) { FactoryGirl.create :reservation, event: event }
      let(:preparation) { reservation }

      scenario 'cannot make a reservation' do
        expect(page).to have_content 'Leider sind alle Plätze bereits vergeben.'
      end

      scenario 'can activate notification' do
        click_link 'Warteliste', href: event_notification_path(event)
        expect(page).to have_content 'Sie wurden auf der Warteliste eingetragen.'
        expect(page).to have_content 'Sie stehen auf der Warteliste'
      end
    end

    context 'with reservation' do
      let(:reservation) { FactoryGirl.create :reservation, event: event, seller: seller }
      let(:preparation) { reservation }

      scenario 'can free reservation' do
        click_link 'geben Sie Ihre Reservierung wieder frei', href: event_reservation_path(event)
        expect(page).to have_content 'Ihre Reservierung wurde freigegeben.'
        expect(page).to have_link 'einen Verkäuferplatz reservieren', href: event_reservation_path(event)
      end

      context 'when other sellers are on notification list' do
        let(:other_seller) { FactoryGirl.create :seller }
        let(:preparation) do
          reservation
          event.update max_sellers: 1
          FactoryGirl.create :notification, seller: other_seller, event: event
        end

        scenario 'notifies sellers on notification list when reservation is freed' do
          click_link 'geben Sie Ihre Reservierung wieder frei', href: event_reservation_path(event)
          open_email other_seller.email
          expect(current_email.subject). to eq 'Verkäuferplatz beim Flohmarkt freigeworden'
          current_email.click_on 'Verkäuferplatz reservieren'
          expect(page).to have_content 'Die Reservierung war erfolgreich. Ihre Reservierungsnummer lautet 1.'
          expect(Notification.count).to be_zero
        end
      end
    end
  end
  it 'is not allowed to review an event which the seller does not have a reservation for'
end
