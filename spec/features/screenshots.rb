require 'rails_helper'
require 'features/admin/login'
require 'rmagick'

RSpec.describe 'Screenshots', js: true do
  def capture(name)
    sleep 1
    file_path = "screenshots/#{name}.png"
    save_screenshot file_path
    puts "Captured #{file_path}"
  end

  def create_item(options)
    click_on 'Artikel hinzufügen'
    select options[:category]
    fill_in 'Beschreibung', with: options[:description]
    fill_in 'Größe', with: options[:size]
    fill_in 'Preis', with: options[:price]
    yield if block_given?
    click_on 'Speichern'
  end

  it 'creates screenshots' do
    admin = FactoryGirl.create :admin, email: 'admin@example.com'
    sellers = FactoryGirl.create_list :random_seller, 30, active: true

    visit admin_path
    fill_in 'eMail-Adresse', with: admin.email
    fill_in 'Passwort', with: 'password'
    capture :admin_login

    click_on 'Anmelden'
    click_on 'Termine'
    capture :admin_events

    click_on 'Neuer Termin'
    fill_in 'Name', with: 'Kinderflohmarkt'
    fill_in 'Details', with: 'Einlass für Schwangere mit Mutterpass (max. 1 Begleitperson) eine halbe Stunde vorher'
    fill_in 'maximale Anzahl Verkäufer', with: 100
    fill_in 'maximale Anzahl Artikel je Verkäufer', with: 50
    fill_in 'Reservierungsstart', with: I18n.localize(2.days.ago, format: :short)
    find('#event_shopping_start').click
    capture :admin_event_new

    click_on 'Termin erstellen'
    capture :admin_event_created
    event = Event.last

    click_on 'Anzeigen'
    capture :admin_event_show

    click_on 'Reservierungen'
    capture :admin_event_reservations

    click_on 'Neue Reservierung'

    sellers.take(15).each { |seller| check seller.label_for_reservation }
    capture :admin_event_reservation_new

    click_on 'Reservierung erstellen'
    capture :admin_event_reservation_created

    click_on 'Verkäufer'
    capture :admin_sellers

    find_link('Anzeigen', href: admin_seller_path(sellers.first)).click
    capture :admin_seller_show

    click_on 'Bearbeiten'
    capture :admin_seller_edit

    click_on 'Änderungen speichern'

    %w(Hose Jacke Puzzle Schuhe Fahhrad Autositz).each { |name| FactoryGirl.create :category, name: name }
    click_on 'Kategorien'
    capture :admin_categories

    click_on 'Neue Kategorie'
    fill_in 'Name', with: 'Spielzeug'
    capture :admin_category_new

    click_on 'Kategorie erstellen'
    capture :admin_category_created

    click_on 'Mails'
    fill_in 'Betreff', with: 'Helfer für unseren kommenden Flohmarkt gesucht'
    fill_in 'Inhalt', with: <<-END
Sehr geehrte Verkäuferin/sehr geehrter Verkäufer

wir benötigen für unseren kommendenden Flohmarkt noch Helfer.

Alle Helfer können bereits zwei Stunden vorm eigentlichen Verkaufsstart einkaufen und bekommen ihre Teilnahmegebühr erlassen.

Wenn Interesse besteht, kontaktieren Sie uns bitte unter der eMail-Adresse hilfe@flohmarkthelfer.de oder rufen Sie uns unter der Nummer 0815/4711 an.

Viele Grüße,
Ihr Flohmarkt-Team
END
    within '.email_active' do
      choose 'Ja'
    end

    within '.email_reservation' do
      choose 'Ja'
    end
    capture :admin_email

    click_on '15 ausgewählt'
    capture :admin_email_select

    find('#admin-info > a').click
    click_on 'Abmelden'
    capture :admin_logout

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

    seller = Seller.find_by_email(email)

    visit login_seller_path(seller.token)
    capture :seller_home

    click_on 'Stammdaten bearbeiten'
    capture :seller_edit

    click_on 'Zurück ohne Speichern der Änderungen'
    click_on 'einen Verkäuferplatz reservieren'
    capture :seller_reservation_created

    reservation = Reservation.last

    click_on 'Artikel bearbeiten'
    capture :seller_items

    create_item category: 'Schuhe', description: 'pink mit Streifen', size: 12, price: '4,00' do
      capture :seller_item_new
    end
    capture :seller_item_created

    Category.all.each do |category|
      FactoryGirl.create_list :random_item, 3, category: category, reservation: reservation
    end
    visit event_items_path(event)
    capture :seller_items_created

    click_on 'Etiketten drucken'
    click_on 'ausgewählt'
    capture :seller_items_print

    event.update shopping_end: 1.hour.ago

    visit seller_path
    capture :seller_home_with_event_finished

    click_on 'Flohmarkt bewerten'
    within('.review_registration') { choose '2' }
    within('.review_total') { choose '3' }
    choose 'Zeitungsanzeige'
    choose 'Ja'
    fill_in 'Welche Dinge haben Ihnen nicht gefallen', with: 'Mehr Farben'

    capture :seller_review
    click_on 'Bewertung abschließen'

    event.reservations.take(10).each do |reservation|
      FactoryGirl.create :random_review, event: reservation.event, seller: reservation.seller
    end

    visit admin_path
    fill_in 'eMail-Adresse', with: admin.email
    fill_in 'Passwort', with: 'password'
    click_on 'Anmelden'
    sleep 3
    capture :admin_home

    find('#admin-info > a').click
    capture :admin_info

    click_on 'Passwort ändern'
    capture :admin_change_password

    visit admin_event_reviews_path(event)
    capture :admin_reviews
  end
end
