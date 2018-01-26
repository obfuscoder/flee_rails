# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Viewing and editing items' do
  let(:reservation) { create :reservation }
  let(:seller) { reservation.seller }
  let!(:category) { create :category }
  let(:preparations) {}
  background do
    preparations
    visit login_seller_path(seller.token)
  end

  context 'when 1 item has been created' do
    let(:preparations) { create :item, reservation: reservation }

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

    describe 'item creation' do
      def create_item
        click_on 'Artikel hinzufügen'
        select category.name, from: 'Kategorie'
        fill_in 'Beschreibung', with: 'blaue Jeans'
        fill_in 'Größe', with: '96'
        fill_in 'Preis', with: '1,90'
        yield if block_given?
        click_on 'Speichern'
      end

      it 'creates new item' do
        create_item
        expect(page).to have_content 'Artikel wurde gespeichert.'
        expect(page).to have_content 'Sie haben aktuell 1 Artikel angelegt.'
        expect(page).to have_content 'Sie können noch 4 Artikel anlegen.'
      end

      context 'when event price precision is 50 cent' do
        before { reservation.event.update price_precision: 0.5 }
        it 'shows error for price precision' do
          create_item
          expect(page).to have_content 'muss ein Vielfaches von 0,50 € sein'
        end
      end

      context 'when donation option is enabled' do
        before { Client.first.update donation_of_unsold_items: true }
        it 'shows unchecked donation option' do
          create_item do
            expect(find_field('Spende wenn nicht verkauft')).not_to be_checked
          end
          expect(Item.last).not_to be_donation
        end

        context 'when donation default option is enabled' do
          before { Client.first.update donation_of_unsold_items_default: true }
          it 'shows checked donation option' do
            create_item do
              expect(find_field('Spende wenn nicht verkauft')).to be_checked
            end
            expect(Item.last).to be_donation
          end
        end

        it 'allows to disable donation option' do
          create_item do
            uncheck 'Spende wenn nicht verkauft'
          end
          expect(Item.last).not_to be_donation
        end

        context 'when donation is enforced' do
          let!(:category) { create :category_with_enforced_donation }
          it 'does not allow to disable donation option' do
            create_item do
              uncheck 'Spende wenn nicht verkauft'
            end
            expect(Item.last).to be_donation
          end
        end
      end

      context 'when donation option is disabled' do
        before { Client.first.update donation_of_unsold_items: false }
        it 'does not show option to donate' do
          create_item do
            expect(page).not_to have_field 'Spende wenn nicht verkauft'
          end
        end
      end
    end

    context 'when items have been created already' do
      let(:items) { create_list :item, 5, reservation: reservation }
      let(:item) { items.first }
      let(:preparations) { items }

      scenario 'shows overview of all items' do
        expect(page).to have_content item.description
        expect(page).to have_content item.category.name
        expect(page).to have_content '1,90 €'
      end

      describe 'edit item' do
        def update_action
          click_link 'Bearbeiten', href: edit_event_reservation_item_path(reservation.event, reservation, item)
          yield if block_given?
          fill_in 'Beschreibung', with: 'blaue Jeans'
          fill_in 'Preis', with: '12,50'
          click_on 'Speichern'
        end
        it 'update item' do
          update_action do
            expect(find_field('Beschreibung').value).to have_content item.description
            expect(find_field('Preis').value).to have_content item.price
          end
          expect(page).to have_content 'Artikel wurde aktualisiert.'
          expect(page).to have_content 'blaue Jeans'
        end

        context 'when donation option is enabled' do
          before { Client.first.update donation_of_unsold_items: true }
          context 'when donation is enforced' do
            let!(:category) { create :category_with_enforced_donation }
            it 'does not allow to disable donation option' do
              update_action do
                select category.name, from: 'Kategorie'
                uncheck 'Spende wenn nicht verkauft'
              end
              expect(item.reload).to be_donation
            end
          end
        end
      end

      scenario 'delete item' do
        expect(page).to have_content 'Sie haben aktuell 5 Artikel angelegt.'
        click_link 'Löschen', href: event_reservation_item_path(reservation.event, reservation, item)
        expect(page).to have_content 'Artikel wurde gelöscht.'
        expect(page).to have_content 'Sie haben aktuell 4 Artikel angelegt.'
      end

      context 'when item limit has been reached' do
        let(:preparations) { items && reservation.event.update(max_items_per_reservation: items.count) }
        scenario 'does not allow to create additional items' do
          expect(page).not_to have_link 'Artikel hinzufügen'
          expect(page).to have_content 'Sie können keine weiteren Artikel anlegen.'
        end
      end

      context 'when labels have been created already' do
        let(:item) { create :item_with_code, reservation: reservation }
        let(:preparations) { item }

        it 'does not show edit/delete link to items with generated labels' do
          expect(page).not_to have_link('Bearbeiten',
                                        href: edit_event_reservation_item_path(reservation.event, reservation, item))
          expect(page).not_to have_link('Löschen',
                                        href: event_reservation_item_path(reservation.event, reservation, item))
        end
      end
    end
  end
end
