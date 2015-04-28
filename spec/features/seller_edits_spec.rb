require 'rails_helper'

RSpec.feature 'Seller edit area' do
  let(:seller) { FactoryGirl.create :seller }
  before do
    visit login_seller_path(seller.token)
  end

  def navigate_to_seller_edit_page
    click_link 'Stammdaten bearbeiten'
  end

  feature 'editing user information' do
    background { navigate_to_seller_edit_page }

    def fill_out_seller_edit_form
      fill_in 'Vorname', with: 'Maximilian'
      fill_in 'Nachname', with: 'Mustermann-Musterfrau'
      fill_in 'Straße', with: 'Neue Straße 2'
      fill_in 'Postleitzahl', with: '54321'
      fill_in 'Ort', with: 'Neudorf'
      fill_in 'Telefonnummer', with: '04711/815815'
    end

    scenario 'user edits master data and saves changes' do
      fill_out_seller_edit_form
      click_button 'Änderungen speichern'
      expect(page).to have_content(/Stammdaten aktualisiert./)
      expect(page).to have_content(/Maximilian/)
      expect(page).to have_content(/Neue Straße 2/)
      expect(seller.reload.first_name).to eq 'Maximilian'
    end

    scenario 'user edits master data and aborts change' do
      expect do
        fill_out_seller_edit_form
        click_link 'Zurück ohne Speichern der Änderungen'
      end.not_to change { seller.reload.first_name }
    end
  end

  feature 'email blocking' do
    background do
      preparation
      navigate_to_seller_edit_page
    end
    let(:preparation) {}
    scenario 'user blocks emails' do
      click_link 'Ich möchte keine eMails mehr erhalten'
      expect(page).to have_content(/Die Mailbenachrichtigungen wurden für Sie deaktiviert./)
      expect(seller.reload.mailing).to eq false
    end

    context 'when mail is blocked' do
      let(:preparation) { seller.update(mailing: false) }
      scenario 'user unblocks emails' do
        click_link 'Ich möchte in Zukunft eMail-Benachrichtigungen erhalten'
        expect(page).to have_content(/Die Mailbenachrichtigungen wurden für Sie aktiviert./)
        expect(seller.reload.mailing).to eq true
      end
    end
  end

  feature 'seller deletion' do
    background { navigate_to_seller_edit_page }
    scenario 'user deletes account' do
      expect do
        click_link 'Ich möchte mich abmelden und meine Daten löschen'
        expect(page).to have_content(/Daten gelöscht/)
      end.to change(Seller, :count).by(-1)
      visit login_seller_path(seller.token)
      expect(page).to have_content(/Anmeldung fehlgeschlagen/)
    end
  end
end
