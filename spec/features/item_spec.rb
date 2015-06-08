require 'rails_helper'

RSpec.feature 'Viewing and editing items' do
  let(:reservation) { FactoryGirl.create :reservation }
  let(:seller) { reservation.seller }
  let!(:category) { FactoryGirl.create :category }
  let(:preparations) {}
  background do
    preparations
    visit login_seller_path(seller.token)
  end

  context 'when 1 item has been created' do
    let(:preparations) { FactoryGirl.create :item, reservation: reservation }

    scenario 'shows number of items for reservation on seller page' do
      expect(page).to have_content 'Sie haben bisher 1 Artikel angelegt.'
    end
  end

  context 'when visiting item overview page for reservation' do
    background { click_on 'Artikel bearbeiten' }

    scenario 'shows number of items' do
      expect(page).to have_content 'Sie haben aktuell 0 Artikel angelegt.'
    end

    scenario 'navigate back to seller home page' do
      click_on 'Zur Hauptseite des gesicherten Bereichs'
      expect(page).to have_content 'Verkäuferbereich'
    end

    scenario 'create new item' do
      click_on 'Artikel hinzufügen'
      select category.name, from: 'Kategorie'
      fill_in 'Beschreibung', with: 'blaue Jeans'
      fill_in 'Größe', with: '96'
      fill_in 'Preis', with: '1,90'
      click_on 'Speichern'
      expect(page).to have_content 'Artikel wurde gespeichert.'
      expect(page).to have_content 'Sie haben aktuell 1 Artikel angelegt.'
    end

    context 'when items have been created already' do
      let(:item1) { FactoryGirl.create :item, reservation: reservation }
      let(:item2) { FactoryGirl.create :item, reservation: reservation }
      let(:preparations) { item1 && item2 }

      scenario 'shows overview of all items' do
        expect(page).to have_content item1.description
        expect(page).to have_content item2.description
        expect(page).to have_content item1.category.name
        expect(page).to have_content item2.category.name
        expect(page).to have_content item1.price
        expect(page).to have_content item2.price
      end

      scenario 'edit item' do
        click_link 'Bearbeiten', href: edit_event_item_path(reservation.event, item1)
        expect(find_field('Beschreibung').value).to have_content item1.description
        expect(find_field('Preis').value).to have_content item1.price
        fill_in 'Beschreibung', with: 'blaue Jeans'
        fill_in 'Preis', with: '12,50'
        click_on 'Speichern'
        expect(page).to have_content 'Artikel wurde aktualisiert.'
        expect(page).to have_content 'blaue Jeans'
      end

      scenario 'delete item' do
        expect(page).to have_content 'Sie haben aktuell 2 Artikel angelegt.'
        click_link 'Löschen', href: event_item_path(reservation.event, item1)
        expect(page).to have_content 'Artikel wurde gelöscht.'
        expect(page).to have_content 'Sie haben aktuell 1 Artikel angelegt.'
      end

      context 'when item limit has been reached' do
        let(:preparations) { item1 && item2 && reservation.event.update(max_items_per_seller: 2) }
        scenario 'does not allow to create additional items' do
          expect(page).not_to have_link 'Artikel hinzufügen'

        end
      end

      context 'when labels have been created already' do
        let(:item) { FactoryGirl.create :item_with_code, reservation: reservation }
        let(:preparations) { item }

        it 'does not show edit/delete link to items with generated labels' do
          expect(page).not_to have_link('Bearbeiten', href: edit_event_item_path(reservation.event, item))
          expect(page).not_to have_link('Löschen', href: event_item_path(reservation.event, item))
        end
      end
    end
  end
end
