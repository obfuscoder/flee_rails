require 'rails_helper'


RSpec.feature 'Registrations' do
  def fill_in_registration_form
    fill_in 'Vorname', with: 'Erika'
    fill_in 'Nachname', with: 'Mustermann'
    fill_in 'Straße', with: 'Am Schlossgarten'
    fill_in 'Postleitzahl', with: '75203'
    fill_in 'Ort', with: 'Königsbach'
    fill_in 'eMail-Adresse', with: 'erika@mustermann.de'
    fill_in 'Telefonnummer', with: '0815/4711'
    check 'Ich akzeptiere die Teilnahmebedingungen und Datenschutzerklärung.'
  end

  def open_mail_and_click_login_link
    open_email 'erika@mustermann.de'
    expect(current_email.subject).to eq 'Registrierungsbestätigung'
    current_email.click_link 'loginlink'
  end

  scenario 'User registers and follows login link in mail' do
    visit '/'
    click_link 'Zur Registrierung'
    fill_in_registration_form
    click_button 'Registrieren'
    expect(page).to have_content 'Registrierung erfolgreich'
    open_mail_and_click_login_link
    expect(page).to have_content 'Verkäuferbereich'
  end
end
