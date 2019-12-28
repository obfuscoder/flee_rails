require 'rails_helper'

RSpec.describe 'Seller edit area' do
  let(:seller) { create :seller }

  before do
    visit login_seller_path(seller.token)
  end

  def navigate_to_seller_edit_page
    click_on 'Stammdaten bearbeiten'
  end

  describe 'editing user information' do
    before { navigate_to_seller_edit_page }

    def fill_out_seller_edit_form
      fill_in 'Vorname', with: 'Maximilian'
      fill_in 'Nachname', with: 'Mustermann-Musterfrau'
      fill_in 'Straße', with: 'Neue Straße 2'
      fill_in 'Postleitzahl', with: '54321'
      fill_in 'Ort', with: 'Neudorf'
      fill_in 'Telefonnummer', with: '04711/815815'
    end

    it 'user edits master data and saves changes' do
      fill_out_seller_edit_form
      click_on 'Änderungen speichern'
      expect(page).to have_content(/Stammdaten aktualisiert./)
      expect(page).to have_content(/Maximilian/)
      expect(page).to have_content(/Neue Straße 2/)
      expect(seller.reload.first_name).to eq 'Maximilian'
    end

    it 'user edits master data and aborts change' do
      expect do
        fill_out_seller_edit_form
        click_on 'Zurück ohne Speichern der Änderungen'
      end.not_to change { seller.reload.first_name }
    end
  end

  describe 'email blocking' do
    before do
      preparation
      navigate_to_seller_edit_page
    end

    let(:preparation) {}

    it 'user blocks emails' do
      click_on 'Ich möchte keine eMails mehr erhalten'
      expect(page).to have_content(/Die Mailbenachrichtigungen wurden für Sie deaktiviert./)
      expect(seller.reload.mailing).to eq false
    end

    context 'when mail is blocked' do
      let(:preparation) { seller.update(mailing: false) }

      it 'user unblocks emails' do
        click_on 'Ich möchte in Zukunft eMail-Benachrichtigungen erhalten'
        expect(page).to have_content(/Die Mailbenachrichtigungen wurden für Sie aktiviert./)
        expect(seller.reload.mailing).to eq true
      end
    end
  end
end
