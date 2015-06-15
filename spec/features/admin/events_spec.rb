require 'rails_helper'

RSpec.feature 'admin events' do
  let!(:events) { FactoryGirl.create_list :event_with_ongoing_reservation, 3 }
  background do
    visit admin_path
    click_on 'Termine'
  end

  scenario 'shows list of events with buttons for show, edit and delete' do
    events.each do |event|
      expect(page).to have_content event.name
      expect(page).to have_content event.shopping_start
      expect(page).to have_content event.reservation_start
      expect(page).to have_link 'Anzeigen', href: admin_event_path(event)
      expect(page).to have_link 'Bearbeiten', href: edit_admin_event_path(event)
      expect(page).to have_link 'Löschen', href: admin_event_path(event)
    end
  end

  scenario 'new event' do
    click_on 'Neuer Termin'
    fill_in 'Name', with: 'Weihnachtsflohmarkt'
    fill_in 'Details', with: 'Kinderbetreuung, Kuchenbasar, viel Platz'
    fill_in 'maximale Anzahl Verkäufer', with: 10
    fill_in 'maximale Anzahl Artikel je Verkäufer', with: 25
    click_on 'Termin erstellen'
    expect(page).to have_content 'Der Termin wurde erfolgreich hinzugefügt.'
  end

  scenario 'delete event' do
    event = events.first
    find("a[href='#{admin_event_path(event)}']", text: 'Löschen').click
    expect(page).to have_content 'Termin gelöscht.'
  end

  feature 'edit event' do
    let(:event) { events.first }
    background do
      find("a[href='#{edit_admin_event_path(event)}']", text: 'Bearbeiten').click
    end

    scenario 'changing event information' do
      new_name = 'Herbstflohmarkt'
      fill_in 'Name', with: new_name
      fill_in 'maximale Anzahl Verkäufer', with: 10
      fill_in 'maximale Anzahl Artikel je Verkäufer', with: 25
      click_on 'Termin aktualisieren'
      expect(page).to have_content 'Der Termin wurde erfolgreich aktualisiert.'
      expect(page).to have_content new_name
    end
  end

  feature 'show event' do
    let(:event) { events.first }
    background do
      find("a[href='#{admin_event_path(event)}']", text: 'Anzeigen').click
    end

    scenario 'shows details about the event' do
      expect(page).to have_content event.name
      expect(page).to have_content event.details
      expect(page).to have_content event.max_sellers
      expect(page).to have_content event.max_items_per_seller
      expect(page).to have_content event.shopping_start
      expect(page).to have_content event.shopping_end
      expect(page).to have_content event.reservation_start
      expect(page).to have_content event.reservation_end
      expect(page).to have_content event.handover_start
      expect(page).to have_content event.handover_end
      expect(page).to have_content event.pickup_start
      expect(page).to have_content event.pickup_end
    end

    scenario 'links to event edit' do
      click_on 'Bearbeiten'
      expect(current_path).to eq edit_admin_event_path(event)
    end

    scenario 'links to reservations for that event' do
      click_on 'Reservierungen'
      expect(current_path).to eq admin_event_reservations_path(event)
    end

    scenario 'links to reviews for that event' do
      click_on 'Bewertungen'
      expect(current_path).to eq admin_event_reviews_path(event)
    end

    feature 'sending mailings' do
      let!(:inactive_seller) { FactoryGirl.create :seller }
      let!(:active_seller) { FactoryGirl.create :seller, active: true }
      let!(:active_seller_with_reservation) { FactoryGirl.create :seller, active: true }
      let!(:seller_without_mailing) { FactoryGirl.create :seller, active: true, mailing: false }
      let!(:reservation) { FactoryGirl.create :reservation, event: event, seller: active_seller_with_reservation }

      scenario 'send invitation to active sellers without reservation' do
        click_on 'Reservierungseinladung verschicken'
        expect(page).to have_content 'Es wurde(n) 1 Einladung(en) verschickt. Es gibt bereits 1 Reservierung(en).'
        expect(page).not_to have_link 'Reservierungseinladung verschicken'
        open_email active_seller.email
        expect(current_email.subject).to eq 'Reservierung zum Flohmarkt startet in Kürze'
        expect(current_email.body).to have_link reserve_seller_url(active_seller.token, event)
      end

      context 'when reservation phase has passed' do
        it 'does not allow to send invitation mail'
      end

      context 'when invitation mail was sent already' do
        it 'does not allow to send invitation mail'
        # is currently included in scenario 'send invitation to active sellers without reservation'
      end

      scenario 'send reservation_closing mail to active sellers with reservation' do
        click_on 'Erinnerungsmail vor Bearbeitungsschluss verschicken'
        expect(page).to have_content 'Es wurde(n) 1 Benachrichtigung(en) verschickt.'
        expect(page).not_to have_link 'Erinnerungsmail vor Bearbeitungsschluss verschicken'
        open_email active_seller_with_reservation.email
        expect(current_email.subject).to eq 'Bearbeitungsfrist der Artikel für den Flohmarkt endet bald'
        expect(current_email.body).to have_link login_seller_url(active_seller_with_reservation.token)
      end

      context 'when reservation phase has not started yet' do
        it 'does not allow to send closing mail'
      end

      context 'when reservation phase has passed already' do
        it 'does not allow to send closing mail'
      end

      context 'when closing mail was sent already' do
        it 'does not allow to send closing mail'
        # is currently included in scenario 'send reservation_closing mail to active sellers with reservation'
      end

      scenario 'send reservation_closed mail to active sellers with reservation' do
        click_on 'Bearbeitungsabschlussmail verschicken'
        expect(page).to have_content 'Es wurde(n) 1 Benachrichtigung(en) verschickt.'
        expect(page).not_to have_link 'Bearbeitungsabschlussmail verschicken'
        open_email active_seller_with_reservation.email
        expect(current_email.subject).to eq 'Flohmarkt Vorbereitungen abgeschlossen - Artikel festgelegt'
        expect(current_email.body).to have_link('Zum geschützten Bereich',
                                                href: login_seller_url(active_seller_with_reservation.token))
      end

      scenario 'closed mail contains attachments with labels as pdf'

      context 'when reservation end was not reached yet' do
        it 'does not allow to send closing mail'
      end

      context 'when closed mail was sent already' do
        it 'does not allow to send closing mail'
        # is currently included in scenario 'send reservation_closed mail to active sellers with reservation'
      end
    end
  end
end
