require 'rails_helper'
require 'features/admin/login'

RSpec.feature 'admin sellers' do
  include_context 'login'
  let!(:sellers) { create_list :seller, 3 }
  let(:seller) { sellers.first }
  background do
    click_on 'Verkäufer'
  end

  scenario 'shows list of sellers with buttons for show, edit and delete' do
    sellers.each do |seller|
      expect(page).to have_content seller.name
      expect(page).to have_content seller.email
      expect(page).to have_content seller.reservations.joins(:items).count
      expect(page).to have_link 'Anzeigen', href: admin_seller_path(seller)
      expect(page).to have_link 'Bearbeiten', href: edit_admin_seller_path(seller)
      expect(page).to have_link 'Löschen', href: admin_seller_path(seller)
    end
  end

  scenario 'new seller' do
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

  scenario 'delete seller' do
    click_link 'Löschen', href: admin_seller_path(seller)
    expect(page).to have_content 'Verkäufer gelöscht.'
  end

  feature 'edit seller' do
    background do
      click_link 'Bearbeiten', href: edit_admin_seller_path(seller)
    end

    scenario 'changing seller information' do
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

  feature 'show seller' do
    let!(:reservation) { create :reservation, seller: seller }
    let!(:items) { create_list :item, 5, reservation: reservation }
    let!(:other_items) { create_list :item, 2 }
    background do
      click_link 'Anzeigen', href: admin_seller_path(seller)
    end

    scenario 'shows details about the seller' do
      expect(page).to have_content seller.name
      expect(page).to have_content seller.street
      expect(page).to have_content seller.city
      expect(page).to have_content seller.email
      expect(page).to have_content reservation.number
      expect(page).to have_content reservation.event.name
      expect(page).to have_content items.count
    end

    feature 'reservation items' do
      let(:item) { items.first }
      let(:preparation) {}
      background do
        preparation
        click_link 'Artikel', href: admin_reservation_items_path(reservation)
      end

      scenario 'lists all items' do
        expect(page).to have_link 'Löschen', count: items.count
        items.each do |item|
          expect(page).to have_content item.description
          expect(page).to have_content item.category.name
          expect(page).to have_link 'Löschen', href: admin_reservation_item_path(reservation, item)
        end
      end

      context 'when label for item exists' do
        let(:item_with_code) { create :item_with_code, reservation: reservation }
        let(:preparation) { item_with_code }

        it 'shows code' do
          expect(page).to have_content item.code
        end
      end

      scenario 'delete item' do
        click_link 'Löschen', href: admin_reservation_item_path(reservation, item)
        expect(page).not_to have_link 'Löschen', href: admin_reservation_item_path(reservation, item)
        expect(page).to have_content 'Artikel gelöscht.'
      end
    end

    scenario 'links to seller edit' do
      click_on 'Bearbeiten'
      expect(current_path).to eq edit_admin_seller_path(seller)
    end

    scenario 'links to items for that seller and reservation' do
      click_on 'Artikel auflisten'
      expect(current_path).to eq admin_reservation_items_path(reservation)
    end
  end
end
