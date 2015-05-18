require 'rails_helper'

RSpec.feature 'Registrations' do
  let(:email) { 'erika@mustermann.de' }
  let(:seller) { Seller.find_by_email email }
  def fill_in_and_submit_registration_form
    fill_in 'Vorname', with: 'Erika'
    fill_in 'Nachname', with: 'Mustermann'
    fill_in 'Straße', with: 'Am Schlossgarten'
    fill_in 'Postleitzahl', with: '75203'
    fill_in 'Ort', with: 'Königsbach'
    fill_in 'eMail-Adresse', with: email
    fill_in 'Telefonnummer', with: '0815/4711'
    check 'Ich akzeptiere die Teilnahmebedingungen und Datenschutzerklärung.'
    click_on 'Registrieren'
  end

  def open_mail_and_click_login_link
    open_email email
    expect(current_email.subject).to eq 'Registrierungsbestätigung'
    current_email.click_on login_seller_url(seller.token)
  end

  scenario 'User registers and follows login link in mail' do
    visit '/'
    click_on 'Zur Registrierung'
    fill_in_and_submit_registration_form
    expect(page).to have_content 'Registrierung erfolgreich'
    expect(seller.active).to eq false
    expect(seller.mailing).to eq true
    open_mail_and_click_login_link
    expect(page).to have_content 'Verkäuferbereich'
    expect(seller.reload.active).to eq true
  end
end