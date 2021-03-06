require 'rails_helper'

RSpec.describe 'labels generation' do
  let(:seller) { create :seller }
  let!(:category) { create :category }
  let(:preparations) {}
  let(:strings_from_rendered_pdf) { PDF::Inspector::Text.analyze(page.body).strings }

  before do
    preparations
    visit login_seller_path(seller.token)
    click_on 'Artikel bearbeiten'
  end

  def check_pdf_for_label(item)
    expect(strings_from_rendered_pdf).to include item.description
    expect(strings_from_rendered_pdf).to include item.category.name
    expect(strings_from_rendered_pdf).to include item.reservation.number.to_s
    expect(strings_from_rendered_pdf).to include item.number.to_s
    expect(strings_from_rendered_pdf).to include item.code
  end

  context 'with items' do
    let(:reservation) { create :reservation, seller: seller }
    let(:items) { create_list :item, 5, reservation: reservation }
    let(:preparations) { items }
    let(:make_selection) {}

    before do
      click_on 'Etiketten drucken'
      make_selection
      click_on 'Drucken'
    end

    it 'creates labels on the fly' do
      expect(page.response_headers['Content-Type']).to eq 'application/pdf'
      items.each do |item|
        expect(item.reload.code).to be_present
        check_pdf_for_label item
      end
    end

    context 'when donation option is enabled' do
      before { Client.first.update donation_of_unsold_items: true }

      context 'when item is being donated' do
        let(:preparations) { items.first.update donation: true }

        it 'contains donation label' do
          expect(strings_from_rendered_pdf).to include 'S'
        end
      end
    end

    context 'when selecting a few of the items' do
      let(:selected_items) { items.take 3 }
      let(:unselected_items) { items - selected_items }
      let(:make_selection) do
        selected_items.each { |item| select item.to_s, from: 'Artikel' }
      end

      it 'generates labels of selected items' do
        selected_items.each do |item|
          expect(item.reload.code).not_to be_nil
          check_pdf_for_label item
        end
      end

      it 'does not generate labels for unselected items' do
        unselected_items.each do |item|
          expect(item.code).to be_nil
        end
      end
    end
  end
end
