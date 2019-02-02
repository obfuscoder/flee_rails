# frozen_string_literal: true

require 'rails_helper'
require 'features/admin/login'

RSpec.describe 'admin sellers' do
  include_context 'when logging in'
  let!(:sellers) { create_list :seller, 3 }
  let(:seller) { sellers.first }

  before do
    click_on 'Verkäufer'
  end

  it 'new seller' do
    click_on 'Neuer Verkäufer'
    fill_in 'Vorname', with: 'Max'
    fill_in 'Nachname', with: 'Mustermann'
    fill_in 'Straße', with: 'Hauptstr. 15'
    fill_in 'Postleitzahl', with: '75203'
    fill_in 'Ort', with: 'Königsbach'
    fill_in 'Telefonnummer', with: '0815/4711'
    fill_in 'eMail-Adresse', with: 'max@mustermann.name'
    click_on 'Registrieren'
    expect(page).to have_content 'Der Verkäufer wurde erfolgreich hinzugefügt.'
  end

  describe 'edit seller' do
    before do
      click_link 'Bearbeiten', href: edit_admin_seller_path(seller)
    end

    it 'changing seller information' do
      new_first_name = 'Maria'
      new_last_name = 'Musterfrau'
      new_name = "#{new_first_name} #{new_last_name}"
      fill_in 'Vorname', with: new_first_name
      fill_in 'Nachname', with: new_last_name
      click_on 'Änderungen speichern'
      expect(page).to have_content 'Der Verkäufer wurde erfolgreich aktualisiert.'
      expect(page).to have_content new_name
    end
  end

  describe 'show seller' do
    let!(:reservation) { create :reservation, seller: seller }
    let!(:items) { create_list :item, 5, reservation: reservation }
    let!(:other_items) { create_list :item, 2 }

    before do
      click_link 'Anzeigen', href: admin_seller_path(seller)
    end

    it 'shows details about the seller' do
      expect(page).to have_content seller.name
      expect(page).to have_content seller.street
      expect(page).to have_content seller.city
      expect(page).to have_content seller.email
      expect(page).to have_content reservation.number
      expect(page).to have_content reservation.event.name
      expect(page).to have_content items.count
    end

    describe 'reservation items' do
      let(:item) { items.first }
      let(:preparation) {}

      before do
        preparation
        click_link 'Artikel', href: admin_reservation_items_path(reservation)
      end

      context 'when label for item exists' do
        let(:item_with_code) { create :item_with_code, reservation: reservation }
        let(:preparation) { item_with_code }

        it 'shows code' do
          expect(page).to have_content item.code
        end
      end
    end

    it 'links to seller edit' do
      click_on 'Bearbeiten'
      expect(page).to have_current_path(edit_admin_seller_path(seller))
    end

    it 'links to items for that seller and reservation' do
      click_on 'Artikel auflisten'
      expect(page).to have_current_path(admin_reservation_items_path(reservation))
    end
  end
end
