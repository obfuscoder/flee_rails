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
    click_link 'Löschen', href: admin_event_path(event)
    expect(page).to have_content 'Termin gelöscht.'
  end

  feature 'edit event' do
    let(:event) { events.first }
    background do
      click_link 'Bearbeiten', href: edit_admin_event_path(event)
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
    def click_on_event
      click_link 'Anzeigen', href: admin_event_path(event)
    end

    scenario 'shows details about the event' do
      click_on_event
      expect(page).to have_content event.name
      expect(page).to have_content event.details
      expect(page).to have_content event.max_sellers
      expect(page).to have_content event.max_items_per_seller
    end

    scenario 'links to event edit' do
      click_on_event
      click_on 'Bearbeiten'
      expect(current_path).to eq edit_admin_event_path(event)
    end

    scenario 'links to reservations for that event' do
      click_on_event
      click_on 'Reservierungen'
      expect(current_path).to eq admin_event_reservations_path(event)
    end

    scenario 'links to reviews for that event' do
      click_on_event
      click_on 'Bewertungen'
      expect(current_path).to eq admin_event_reviews_path(event)
    end

    feature 'sending mailings' do
      let!(:inactive_seller) { FactoryGirl.create :seller }
      let!(:active_seller) { FactoryGirl.create :seller, active: true }
      let!(:active_seller_with_reservation) { FactoryGirl.create :seller, active: true }
      let!(:seller_without_mailing) { FactoryGirl.create :seller, active: true, mailing: false }
      let!(:reservation) { FactoryGirl.create :reservation, event: event, seller: active_seller_with_reservation }
      let!(:items) { FactoryGirl.create_list :item, 5, reservation: reservation }

      scenario 'send invitation to active sellers without reservation' do
        click_on_event
        click_on 'Reservierungseinladung verschicken'
        expect(page).to have_content 'Es wurde(n) 1 Einladung(en) verschickt. Es gibt bereits 1 Reservierung(en).'
        open_email active_seller.email
        expect(current_email.subject).to eq 'Reservierung zum Flohmarkt startet in Kürze'
        expect(current_email.body).to have_link 'Verkäuferplatz reservieren',
                                                href: login_seller_url(active_seller.token, goto: :reserve, event: event)
      end

      context 'when reservation phase has passed' do
        before { Timecop.freeze event.reservation_end + 1.hour }
        after { Timecop.return }
        it 'does not allow to send invitation mail' do
          click_on_event
          expect(page).not_to have_link 'Reservierungseinladung verschicken'
        end
      end

      context 'when invitation mail was sent already' do
        let!(:message) { FactoryGirl.create :invitation_message, event: event }
        it 'does not allow to send invitation mail' do
          click_on_event
          expect(page).not_to have_link 'Reservierungseinladung verschicken'
        end
      end

      scenario 'send reservation_closing mail to active sellers with reservation' do
        click_on_event
        click_on 'Erinnerungsmail vor Bearbeitungsschluss verschicken'
        expect(page).to have_content 'Es wurde(n) 1 Benachrichtigung(en) verschickt.'
        open_email active_seller_with_reservation.email
        expect(current_email.subject).to eq 'Bearbeitungsfrist der Artikel für den Flohmarkt endet bald'
        expect(current_email.body).to have_link 'Zum geschützten Bereich',
                                                href: login_seller_url(active_seller_with_reservation.token)
      end

      context 'when reservation phase has not started yet' do
        before { Timecop.freeze event.reservation_start - 1.hour }
        after { Timecop.return }
        it 'does not allow to send closing mail' do
          click_on_event
          expect(page).not_to have_link 'Erinnerungsmail vor Bearbeitungsschluss verschicken'
        end
      end

      context 'when reservation phase has passed already' do
        before { Timecop.freeze event.reservation_end + 1.hour }
        after { Timecop.return }
        it 'does not allow to send closing mail' do
          click_on_event
          expect(page).not_to have_link 'Erinnerungsmail vor Bearbeitungsschluss verschicken'
        end
      end

      context 'when closing mail was sent already' do
        let!(:message) { FactoryGirl.create :reservation_closing_message, event: event }
        it 'does not allow to send closing mail' do
          click_on_event
          expect(page).not_to have_link 'Erinnerungsmail vor Bearbeitungsschluss verschicken'
        end
      end

      describe 'sending reservation_closed mail' do
        before do
          Timecop.freeze event.reservation_end + 1.hour do
            click_on_event
            click_on 'Bearbeitungsabschlussmail verschicken'
            expect(page).to have_content 'Es wurde(n) 1 Benachrichtigung(en) verschickt.'
            open_email active_seller_with_reservation.email
          end
        end

        it 'creates codes for all items of reservations' do
          items.each do |item|
            item.reload
            expect(item.code).not_to be_nil
            expect(item.number).not_to be_nil
          end
        end

        describe 'sent mail' do
          subject(:email) { current_email }
          its(:subject) { is_expected.to eq 'Flohmarkt Vorbereitungen abgeschlossen - Artikel festgelegt' }
          its(:body) do
            is_expected.to have_link('Zum geschützten Bereich',
                                     href: login_seller_url(active_seller_with_reservation.token))
          end
          describe 'attached pdf' do
            subject(:attachment) { email.attachments[0] }
            let(:strings_from_attached_pdf) { PDF::Inspector::Text.analyze(attachment.body.decoded).strings }

            it 'contains all labels' do
              items.each do |item|
                expect(strings_from_attached_pdf).to include item.reload.code
              end
            end
          end
        end
      end

      context 'when reservation end was not reached yet' do
        before { Timecop.freeze event.reservation_end - 1.hour }
        after { Timecop.return }
        it 'does not allow to send closed mail' do
          click_on_event
          expect(page).not_to have_link 'Bearbeitungsabschlussmail verschicken'
        end
      end

      context 'when closed mail was sent already' do
        let!(:message) { FactoryGirl.create :reservation_closed_message, event: event }
        it 'does not allow to send closed mail' do
          click_on_event
          expect(page).not_to have_link 'Bearbeitungsabschlussmail verschicken'
        end
      end
      feature 'finished mail' do
        context 'when event has not passed yet' do
          it 'does not allow to send mail' do
            click_on_event
            expect(page).not_to have_link 'Abschlussmail verschicken'
          end
        end

        context 'when event has passed' do
          before do
            Timecop.freeze event.shopping_end + 1.hour
            click_on_event
            click_on 'Abschlussmail verschicken'
          end
          after { Timecop.return }

          it 'shows number of sent mails to reservations' do
            expect(page).to have_content 'Es wurde(n) 1 Benachrichtigung(en) verschickt.'
          end

          describe 'sent email' do
            subject(:mail) do
              open_email active_seller_with_reservation.email
              current_email
            end
            its(:subject) { is_expected.to eq 'Flohmarktergebnisse verfügbar - Bitte bewerten Sie uns' }
            it 'links to event review' do
              mail.click_on 'Zur Bewertung des Flohmarkts'
              expect(current_path).to eq new_event_review_path(event)
            end
            it 'links to event summary' do
              mail.click_on 'Zu den Flohmarktergebnissen'
              expect(current_path).to eq event_path(event)
            end
          end
        end
      end
    end
  end
end
