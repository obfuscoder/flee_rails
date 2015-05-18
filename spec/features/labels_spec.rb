require 'rails_helper'

RSpec.feature 'labels generation' do
  let(:seller) { FactoryGirl.create :seller }
  let!(:category) { FactoryGirl.create :category }
  let(:preparations) {}
  background do
    preparations
    visit login_seller_path(seller.token)
    click_on 'Artikel bearbeiten'
  end

  context 'with items' do
    let(:items) { FactoryGirl.create_list :item, 30, seller: seller }
    context 'with one reservation' do
      let(:reservation) { FactoryGirl.create :reservation, seller: seller }
      let(:preparations) { items && reservation }
      let(:strings_from_rendered_pdf) { PDF::Inspector::Text.analyze(page.body).strings }
      before do
        click_on 'Etiketten drucken'
        click_on 'Drucken'
      end

      it 'creates labels on the fly' do
        expect(page.response_headers['Content-Type']).to eq 'application/pdf'
        items.each do |item|
          expect(item.reserved_items.count).to eq 1
          expect(strings_from_rendered_pdf).to include item.description
          expect(strings_from_rendered_pdf).to include item.category.name
          expect(strings_from_rendered_pdf).to include "#{reservation.number} - #{item.reserved_items.first.number}"
          expect(strings_from_rendered_pdf).to include item.reserved_items.first.code
        end
      end

      it 'autogenerates proper codes' do
        text_analysis = PDF::Inspector::Text.analyze(page.body)
        expect(text_analysis.strings).to include '010020016'
      end

      context 'when adding additional items and printing everything' do
        let(:more_items) { FactoryGirl.create_list :item, 10, seller: seller }
        before do
          visit items_path
          more_items
          click_on 'Etiketten drucken'
          click_on 'Drucken'
        end

        it 'does not generate more labels for existing items' do
          items.each do |item|
            expect(item.reserved_items.count).to eq 1
          end
        end

        it 'creates labels for additional items on the fly' do
          more_items.each do |item|
            expect(item.reserved_items.count).to eq 1
            expect(strings_from_rendered_pdf).to include item.description
            expect(strings_from_rendered_pdf).to include item.category.name
            expect(strings_from_rendered_pdf).to include "#{reservation.number} - #{item.reserved_items.first.number}"
            expect(strings_from_rendered_pdf).to include item.reserved_items.first.code
          end
        end
      end

      it 'blocks items with generated labels for editing'

      context 'when selecting a few of the items' do
        it 'generates labels of selected items'
      end
    end

    context 'without any reservation' do
      let(:preparations) { items }
      it 'cannot print labels' do
        expect(page).not_to have_content 'Etiketten drucken'
      end
      it 'shows info that label printing is only possible with reservation' do
        expect(page).to have_content 'Sobald Sie eine Reservierung haben'
      end
    end

    context 'with more than one reservation' do
      let(:reservation1) { FactoryGirl.create :reservation, seller: seller }
      let(:reservation2) { FactoryGirl.create :reservation, seller: seller }
      let(:preparations) { items && reservation1 && reservation2 }
      it 'asks for the reservation to print labels for'
      it 'does not allow to generate labels for items with labels for other reservation'
    end
  end
  context 'with too many items for reservation' do
    it 'selects items for reservation'
    context 'when some labels have been created before' do
      it 'allows to generate additional labels up to the reservation limit'
    end
  end
end
