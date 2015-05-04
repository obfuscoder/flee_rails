require 'rails_helper'

RSpec.feature 'Viewing and editing items' do
  let(:seller) { FactoryGirl.create :seller }
  let!(:category) { FactoryGirl.create :category }
  let(:preparations) {}
  background do
    preparations
    visit login_seller_path(seller.token)
  end

  feature 'when 1 item has been created' do
    let(:preparations) { FactoryGirl.create :item, seller: seller }

    scenario 'shows number of items on seller page' do
      expect(page).to have_content 'Sie haben bisher 1 Artikel angelegt.'
    end
  end

  feature 'when visiting item overview page' do
    background { click_on 'Artikel bearbeiten' }

    scenario 'shows number of items' do
      expect(page).to have_content 'Sie haben aktuell 0 Artikel angelegt.'
    end

    scenario 'allows to navigate back to seller home page' do
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

    feature 'when items have been created already' do
      let(:item1) { FactoryGirl.create :item, seller: seller }
      let(:item2) { FactoryGirl.create :item, seller: seller }
      let(:preparations) { item1 && item2 }

      scenario 'shows overview of all items' do
        expect(page).to have_content item1.description
        expect(page).to have_content item2.description
        expect(page).to have_content item1.category.name
        expect(page).to have_content item2.category.name
        expect(page).to have_content item1.price
        expect(page).to have_content item2.price
      end

      scenario 'allows to edit item' do
        click_link 'Bearbeiten', href: edit_item_path(item1)
        expect(find_field('Beschreibung').value).to have_content item1.description
        expect(find_field('Preis').value).to have_content item1.price
        fill_in 'Beschreibung', with: 'blaue Jeans'
        fill_in 'Preis', with: '12,50'
        click_on 'Speichern'
        expect(page).to have_content 'Artikel wurde aktualisiert.'
        expect(page).to have_content 'blaue Jeans'
      end

      scenario 'allows to delete item' do
        expect(page).to have_content 'Sie haben aktuell 2 Artikel angelegt.'
        click_link 'Löschen', href: item_path(item1)
        expect(page).to have_content 'Artikel wurde gelöscht.'
        expect(page).to have_content 'Sie haben aktuell 1 Artikel angelegt.'
      end
    end
  end
end
