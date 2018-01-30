# frozen_string_literal: true

require 'rails_helper'
require 'features/admin/login'

RSpec.feature 'admin event reservations' do
  include_context 'login'
  let(:event) { create :event_with_ongoing_reservation, max_reservations: 5 }
  let!(:sellers) { create_list :seller, 4, active: true }
  let(:number_of_reservations) { 3 }
  let!(:reservations) { create_list :reservation, number_of_reservations, event: event }
  background do
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

  feature 'new reservation' do
    shared_examples 'create reservations for selected sellers' do
      before do
        click_on 'Neue Reservierung'
        selection.each { |seller| check seller.label_for_selects }
        click_on 'Reservierung erstellen'
      end

      it 'creates reservations for selected sellers' do
        expect(page).to have_content "#{selection.count} Reservierungen erfolgreich durchgeführt"
        selection.each do |seller|
          expect(page).to have_link 'Löschen', href: admin_event_reservation_path(event, seller.reservations.first)
        end
      end
    end

    it_behaves_like 'create reservations for selected sellers' do
      let(:selection) { sellers.take(2) }
    end

    context 'when reservation limit is being reached' do
      it_behaves_like 'create reservations for selected sellers' do
        let(:selection) { sellers.take(3) }
      end
    end

    context 'when reservation period has not started yet' do
      before { Timecop.travel event.reservation_start - 1.hour }
      after { Timecop.return }

      it_behaves_like 'create reservations for selected sellers' do
        let(:selection) { sellers.take(2) }
      end
    end
  end

  scenario 'free reservation' do
    click_link 'Löschen', href: admin_event_reservation_path(event, reservations.first)
    expect(page).to have_content 'Die Reservierung wurde gelöscht'
    expect(page).not_to have_link 'Löschen', href: admin_event_reservation_path(event, reservations.first)
  end

  context 'with sellers on notification list' do
    let(:selection) { sellers.take(2) }
    let!(:notifications) { selection.map { |seller| create :notification, event: event, seller: seller } }
  end
end
