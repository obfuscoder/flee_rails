# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Seller view area' do
  let(:seller) { create :seller }
  let(:preparation) {}

  before do
    preparation
    login
  end

  def login
    visit login_seller_path(seller.token)
  end

  it 'private home page is shown after login' do
    expect(page).to have_content 'Verkäuferbereich'
  end

  it 'shows seller address information' do
    expect(page).to have_content seller.first_name
    expect(page).to have_content seller.street
  end

  context 'with event' do
    let(:event) { create :event_with_ongoing_reservation, max_reservations: 1 }
    let(:preparation) { event }

    it 'can make a reservation' do
      click_link 'Verkäuferplatz reservieren', href: event_reservations_path(event)
      expect(page).to have_content 'Die Reservierung war erfolgreich. Ihre Reservierungsnummer lautet 1.'
      expect(page).to have_content 'Sie haben die Reservierungsnummer 1'
      expect(page).to have_link 'Reservierung freigeben', href: event_reservation_path(event, event.reservations.first)
    end

    context 'when reservation period is not yet reached' do
      let(:event) { create :event_with_ongoing_reservation, reservation_start: 1.hour.from_now }

      it 'reservation is not possible' do
        expect(page).not_to have_link 'Verkäuferplatz reservieren', href: event_reservations_path(event)
      end
    end

    context 'when reservation period has passed' do
      let(:event) { create :event_with_ongoing_reservation, reservation_end: 1.hour.ago }

      it 'reservation is not possible' do
        expect(page).not_to have_link 'Verkäuferplatz reservieren', href: event_reservations_path(event)
      end
    end

    context 'with reservation limit reached' do
      let(:reservation) { create :reservation, event: event }
      let(:preparation) { reservation }

      it 'cannot make a reservation' do
        expect(page).to have_content 'Leider sind alle Plätze bereits vergeben.'
      end

      it 'can activate notification' do
        click_link 'Warteliste', href: event_notification_path(event)
        expect(page).to have_content 'Sie wurden auf der Warteliste eingetragen.'
        expect(page).to have_content 'Sie stehen auf der Warteliste'
      end
    end

    context 'with reservation' do
      let(:reservation) { create :reservation, event: event, seller: seller }
      let(:preparation) { reservation }

      it 'can free reservation' do
        click_link 'Reservierung freigeben', href: event_reservation_path(event, reservation)
        expect(page).to have_content 'Ihre Reservierung wurde freigegeben.'
        expect(page).to have_link 'Verkäuferplatz reservieren', href: event_reservations_path(event)
      end
    end
  end
end
