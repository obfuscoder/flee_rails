require 'rails_helper'

RSpec.feature 'Screenshots', js: true do
  def capture(name)
    save_screenshot "screenshots/#{name}.png"
  end

  scenario 'action' do
    email = 'erika.mustermann@beispiel.de'

    visit root_path
    capture :home

    click_on 'Zur Registrierung'
    fill_in 'Vorname', with: 'Erika'
    fill_in 'Nachname', with: 'Mustermann'
    fill_in 'Straße', with: 'Musterstraße'
    fill_in 'Postleitzahl', with: '75203'
    fill_in 'Ort', with: 'Musterhausen'
    fill_in 'eMail-Adresse', with: email
    fill_in 'Telefonnummer', with: '0815/4711-1234'
    check 'Ich akzeptiere die Teilnahmebedingungen und Datenschutzerklärung.'
    capture :registration

    click_on 'Registrieren'
    capture :registration_done

    visit login_seller_path(Seller.find_by_email(email).token)
    capture :seller_home
  end
end
