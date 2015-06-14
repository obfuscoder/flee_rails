require 'rails_helper'

RSpec.feature 'admin event reservations' do
  let(:event) { FactoryGirl.create :event_with_ongoing_reservation, max_sellers: 5 }
  let!(:sellers) { FactoryGirl.create_list :seller, 4, active: true }
  let!(:reservations) { FactoryGirl.create_list :reservation, 3, event: event }
  background do
    visit admin_path
    click_on 'Termine'
    click_on 'Anzeigen'
    click_on 'Reservierungen'
  end

  scenario 'shows list of reservations with delete action and link to seller show' do
    reservations.each do |reservation|
      expect(page).to have_content reservation.number
      expect(page).to have_link reservation.seller.name, href: admin_seller_path(reservation.seller)
      expect(page).to have_content reservation.seller.city
      expect(page).to have_content reservation.seller.email
      expect(page).to have_link 'Löschen', href: admin_event_reservation_path(event, reservation)
    end
  end

  scenario 'new reservation' do
    click_on 'Neue Reservierung'
    sellers.take(2).each { |seller| check seller.label_for_reservation }
    click_on 'Reservierung erstellen'
    expect(page).to have_content '2 Reservierungen erfolgreich durchgeführt'
    expect(page).to have_link 'Löschen', count: 5
  end

  scenario 'allows reservation even if limit is reached' do
    click_on 'Neue Reservierung'
    sellers.take(3).each { |seller| check seller.label_for_reservation }
    click_on 'Reservierung erstellen'
    expect(page).to have_content '3 Reservierungen erfolgreich durchgeführt'
    expect(page).to have_link 'Löschen', count: 6
  end
  scenario 'allows reservation even if reservation period has not started yet' do
    Timecop.freeze event.reservation_start - 1.hour do
      click_on 'Neue Reservierung'
      sellers.take(2).each { |seller| check seller.label_for_reservation }
      click_on 'Reservierung erstellen'
      expect(page).to have_content '2 Reservierungen erfolgreich durchgeführt'
      expect(page).to have_link 'Löschen', count: 5
    end
  end

  scenario 'notifies sellers on notification list when reservation is freed'
end
