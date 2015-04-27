require 'rails_helper'

def navigate_to_seller_edit_page
  click_link 'Stammdaten bearbeiten'
  expect(current_path).to eq edit_seller_path
end

def fill_out_seller_edit_form
  fill_in 'Vorname', with: 'Maximilian'
  fill_in 'Nachname', with: 'Mustermann-Musterfrau'
  fill_in 'Straße', with: 'Neue Straße 2'
  fill_in 'Postleitzahl', with: '54321'
  fill_in 'Ort', with: 'Neudorf'
  fill_in 'Telefonnummer', with: '04711/815815'
end

RSpec.feature 'Seller edit area' do
  let(:seller) { FactoryGirl.create :seller }
  background do
    visit login_seller_path(seller.token)
    expect(current_path).to eq seller_path
  end

  scenario 'user edits master data and saves changes' do
    navigate_to_seller_edit_page
    fill_out_seller_edit_form
    click_button 'Änderungen speichern'
    expect(current_path).to eq seller_path
    expect(page).to have_content(/Stammdaten aktualisiert./)
    expect(page).to have_content(/Maximilian/)
    expect(page).to have_content(/Neue Straße 2/)
  end

  scenario 'user edits master data and aborts change' do
    navigate_to_seller_edit_page
    expect {
      fill_out_seller_edit_form
      click_link 'Zurück ohne Speichern der Änderungen'
      expect(current_path).to eq seller_path
    }.not_to change{seller.reload.first_name}
  end

  feature 'email blocking' do
    scenario 'user blocks emails' do
      navigate_to_seller_edit_page
      click_link 'Ich möchte keine eMails mehr erhalten'
      expect(current_path).to eq seller_path
      expect(page).to have_content(/Die Mailbenachrichtigungen wurden für Sie deaktiviert./)
      expect(seller.reload.mailing).to eq false
    end

    context 'when mail is blocked' do
      background { seller.update(mailing: false) }

      scenario 'user unblocks emails' do
        navigate_to_seller_edit_page
        click_link 'Ich möchte in Zukunft eMail-Benachrichtigungen erhalten'
        expect(current_path).to eq seller_path
        expect(page).to have_content(/Die Mailbenachrichtigungen wurden für Sie aktiviert./)
        expect(seller.reload.mailing).to eq true
      end
    end
  end
end
