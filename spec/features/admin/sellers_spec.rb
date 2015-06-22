require 'rails_helper'

RSpec.feature 'admin sellers' do
  let!(:sellers) { FactoryGirl.create_list :seller, 3 }
  let(:seller) { sellers.first }
  background do
    visit admin_path
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
    find("a[href='#{admin_seller_path(seller)}']", text: 'Löschen').click
    expect(page).to have_content 'Verkäufer gelöscht.'
  end

  feature 'edit seller' do
    background do
      find("a[href='#{edit_admin_seller_path(seller)}']", text: 'Bearbeiten').click
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
    let!(:reservation) { FactoryGirl.create :reservation, seller: seller }
    let!(:items) { FactoryGirl.create_list :item, 5, reservation: reservation }
    background do
      find("a[href='#{admin_seller_path(seller)}']", text: 'Anzeigen').click
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
        find("a[href='#{admin_reservation_items_path(reservation)}']", text: 'Artikel').click
      end

      scenario 'lists all items' do
        items.each do |item|
          expect(page).to have_content item.description
          expect(page).to have_content item.category.name
          expect(page).to have_link 'Bearbeiten', href: edit_admin_reservation_item_path(reservation, item)
          expect(page).to have_link 'Löschen', href: admin_reservation_item_path(reservation, item)
        end
      end

      scenario 'edit item' do
        new_description = 'Neue Beschreibung'
        find("a[href='#{edit_admin_reservation_item_path(reservation, item)}']", text: 'Bearbeiten').click
        fill_in 'Beschreibung', with: new_description
        click_on 'Speichern'
        expect(page).to have_content new_description
      end

      context 'when label for item exists' do
        let(:item_with_code) { FactoryGirl.create :item_with_code, reservation: reservation }
        let(:preparation) { item_with_code }

        scenario 'cannot edit item' do
          expect(page).not_to have_link 'Bearbeiten',
                                        href: edit_admin_reservation_item_path(reservation, item_with_code)
        end

        scenario 'can delete item' do
          expect(page).to have_link 'Löschen', href: admin_reservation_item_path(reservation, item)
        end
      end

      scenario 'delete item' do
        find("a[href='#{admin_reservation_item_path(reservation, item)}']", text: 'Löschen').click
        expect(page).not_to have_link 'Bearbeiten', href: edit_admin_reservation_item_path(reservation, item)
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