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
    let(:items) { (1..30).map { |_i| FactoryGirl.create :item, seller: seller } }
    context 'with one reservation' do
      let(:reservation) { FactoryGirl.create :reservation, seller: seller }
      let(:preparations) { items && reservation }
      it 'creates labels on the fly' do
        click_on 'Etiketten drucken'
        click_on 'Drucken'
        expect(page.response_headers['Content-Type']).to eq 'application/pdf'
      end

      it 'autogenerates proper codes'
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
    end
  end
end
