require 'rails_helper'

RSpec.feature 'labels generation' do
  let(:seller) { FactoryGirl.create :seller }
  let!(:category) { FactoryGirl.create :category }
  let(:preparations) {}
  let(:strings_from_rendered_pdf) { PDF::Inspector::Text.analyze(page.body).strings }

  background do
    preparations
    visit login_seller_path(seller.token)
    click_on 'Artikel bearbeiten'
  end

  def check_pdf_for_label(label)
    expect(strings_from_rendered_pdf).to include label.item.description
    expect(strings_from_rendered_pdf).to include label.item.category.name
    expect(strings_from_rendered_pdf).to include "#{label.reservation.number} - #{label.number}"
    expect(strings_from_rendered_pdf).to include label.code
  end

  context 'with items' do
    let(:items) { FactoryGirl.create_list :item, 5, seller: seller }
    context 'with one reservation' do
      let(:reservation) { FactoryGirl.create :reservation, seller: seller }
      let(:preparations) { items && reservation }
      let(:make_selection) {}
      before do
        click_on 'Etiketten drucken'
        make_selection
        click_on 'Drucken'
      end

      it 'creates labels on the fly' do
        expect(page.response_headers['Content-Type']).to eq 'application/pdf'
        items.each do |item|
          expect(item.labels.count).to eq 1
          check_pdf_for_label item.labels.first
        end
      end

      context 'when selecting a few of the items' do
        let(:selected_items) { items.take 3 }
        let(:unselected_items) { items - selected_items }
        let(:make_selection) do
          selected_items.each { |item| find("input[type='checkbox'][value='#{item.id}']").set(true) }
          unselected_items.each { |item| find("input[type='checkbox'][value='#{item.id}']").set(false) }
        end

        it 'generates labels of selected items' do
          selected_items.each do |item|
            expect(item.labels.count).to eq 1
            check_pdf_for_label item.labels.first
          end
        end

        it 'does not generate labels for unselected items' do
          unselected_items.each do |item|
            expect(item.labels).to be_empty
          end
        end
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
