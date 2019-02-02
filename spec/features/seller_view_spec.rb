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
      click_link 'Reservierungsanfrage stellen', href: event_reservations_path(event)
      expect(page).to have_content 'Die Reservierungsanfrage wird verarbeitet.'
      expect(page).to have_content 'Ihre Reservierungsanfrage wird verarbeitet.'
    end

    context 'when reservation period is not yet reached' do
      let(:event) { create :event_with_ongoing_reservation, reservation_start: 1.hour.from_now }

      it 'reservation is not possible' do
        expect(page).not_to have_link 'Reservierungsanfrage stellen', href: event_reservations_path(event)
      end
    end

    context 'when reservation period has passed' do
      let(:event) { create :event_with_ongoing_reservation, reservation_end: 1.hour.ago }

      it 'reservation is not possible' do
        expect(page).not_to have_link 'Reservierungsanfrage stellen', href: event_reservations_path(event)
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
  end
end
