require 'rails_helper'
require 'features/admin/login'
require 'features/mail_support'

RSpec.describe 'admin events' do
  include_context 'when logging in'
  let!(:events) { create_list :event_with_ongoing_reservation, 3 }

  before { click_on 'Termine' }

  it 'shows list of events with buttons for show, edit' do
    events.each do |event|
      expect(page).to have_content event.name
      expect(page).to have_link 'Anzeigen', href: admin_event_path(event)
      expect(page).to have_link 'Bearbeiten', href: edit_admin_event_path(event)
    end
  end

  it 'new event' do
    click_on 'Neuer Termin'
    fill_in 'Name', with: 'Weihnachtsflohmarkt'
    fill_in 'Details', with: 'Kinderbetreuung, Kuchenbasar, viel Platz'
    fill_in 'maximale Anzahl Reservierungen', with: 10
    fill_in 'maximale Anzahl Artikel je Reservierung', with: 25
    click_on 'Termin erstellen'
    expect(page).to have_content 'Der Termin wurde erfolgreich hinzugefügt.'
  end

  it 'price precision defaults to brand setting when creating event' do
    click_on 'Neuer Termin'
    expect(find_field('Basis für Preisangaben').value).to eq '0.1'
  end

  it 'reservation fee prefilled with brand setting' do
    click_on 'Neuer Termin'
    expect(find_field('event_reservation_fee').value).to eq '2.0'
  end

  describe 'donation option' do
    context 'when disabled' do
      before { Client.first.update donation_of_unsold_items: false }

      it 'donation option is not available when creating event' do
        click_on 'Neuer Termin'
        expect(page).not_to have_field 'Spenden nicht verkaufter Artikel aktiviert'
      end
    end

    context 'when enabled' do
      before { Client.first.update donation_of_unsold_items: true }

      it 'donation option is preselected when creating event' do
        click_on 'Neuer Termin'
        expect(find_field('Spenden nicht verkaufter Artikel aktiviert')).to be_checked
      end
    end
  end

  it 'commission rate defaults to brand setting when creating event' do
    click_on 'Neuer Termin'
    expect(find_field('Umsatzanteil für Kommission').value).to eq '0.2'
  end

  describe 'edit event' do
    let(:event) { events.first }

    before do
      click_link 'Bearbeiten', href: edit_admin_event_path(event)
    end

    it 'changing event information' do
      new_name = 'Herbstflohmarkt'
      fill_in 'Name', with: new_name
      fill_in 'maximale Anzahl Reservierungen', with: 10
      fill_in 'maximale Anzahl Artikel je Reservierung', with: 25
      click_on 'Termin aktualisieren'
      expect(page).to have_content 'Der Termin wurde erfolgreich aktualisiert.'
      expect(page).to have_content new_name
    end
  end

  describe 'show event' do
    let(:event) { events.first }

    def click_on_event
      click_link 'Anzeigen', href: admin_event_path(event)
    end

    it 'shows details about the event' do
      click_on_event
      expect(page).to have_content event.name
      expect(page).to have_content event.details
      expect(page).to have_content event.max_reservations
      expect(page).to have_content event.max_items_per_reservation
      expect(page).to have_content '20%' # commission rate
      expect(page).to have_content '2,00 €' # seller fee
    end

    context 'when donation option is enabled' do
      before { Client.first.update donation_of_unsold_items: true }

      it 'shows donation option' do
        click_on_event
        expect(page).to have_content 'Spenden nicht verkaufter Artikel aktiviert'
      end
    end

    it 'links to event edit' do
      click_on_event
      click_on 'Bearbeiten'
      expect(page).to have_current_path(edit_admin_event_path(event))
    end

    it 'links to reservations for that event' do
      click_on_event
      click_on 'Reservierungen'
      expect(page).to have_current_path(admin_event_reservations_path(event))
    end

    it 'links to reviews for that event' do
      Timecop.freeze event.pickup_periods.last.max do
        click_on_event
        click_on 'Bewertungen'
        expect(page).to have_current_path(admin_event_reviews_path(event))
      end
    end

    describe 'sending mailings' do
      let!(:inactive_seller) { create :seller, active: false }
      let!(:active_seller) { create :seller }
      let!(:active_seller_with_reservation) { create :seller }
      let!(:seller_without_mailing) { create :seller, mailing: false }
      let!(:reservation) { create :reservation, event: event, seller: active_seller_with_reservation }
      let!(:items) { create_list :item, 5, reservation: reservation }

      it 'send invitation to active sellers without reservation' do
        click_on_event
        click_on 'Reservierungseinladung verschicken'
        expect(page).to have_content 'Es wird eine Einladung verschickt. Es gibt bereits 1 Reservierung(en).'
        send_and_open_email active_seller.email
        expect(current_email.subject).to eq 'Reservierung zum Flohmarkt startet in Kürze'
        expect(current_email.body).to have_link 'Verkäuferplatz reservieren'
      end

      context 'when reservation phase has passed' do
        before { Timecop.travel event.reservation_end + 1.hour }

        after { Timecop.return }

        it 'does not allow to send invitation mail' do
          click_on_event
          expect(page).not_to have_link 'Reservierungseinladung verschicken'
        end
      end

      context 'when invitation mail was sent already' do
        let!(:message) { create :invitation_message, event: event }

        it 'does not allow to send invitation mail' do
          click_on_event
          expect(page).not_to have_link 'Reservierungseinladung verschicken'
        end
      end

      it 'send reservation_closing mail to active sellers with reservation' do
        click_on_event
        click_on 'Erinnerungsmail vor Bearbeitungsschluss verschicken'
        expect(page).to have_content 'Es wird eine Benachrichtigung verschickt.'
        send_and_open_email active_seller_with_reservation.email
        expect(current_email.subject).to eq 'Bearbeitungsfrist der Artikel für den Flohmarkt endet bald'
        expect(current_email.body).to have_link 'Zum geschützten Bereich'
      end

      context 'when reservation phase has not started yet' do
        before { Timecop.travel event.reservation_start - 1.hour }

        after { Timecop.return }

        it 'does not allow to send closing mail' do
          click_on_event
          expect(page).not_to have_link 'Erinnerungsmail vor Bearbeitungsschluss verschicken'
        end
      end

      context 'when reservation phase has passed already' do
        before { Timecop.travel event.reservation_end + 1.hour }

        after { Timecop.return }

        it 'does not allow to send closing mail' do
          click_on_event
          expect(page).not_to have_link 'Erinnerungsmail vor Bearbeitungsschluss verschicken'
        end
      end

      context 'when closing mail was sent already' do
        let!(:message) { create :reservation_closing_message, event: event }

        it 'does not allow to send closing mail' do
          click_on_event
          expect(page).not_to have_link 'Erinnerungsmail vor Bearbeitungsschluss verschicken'
        end
      end

      describe 'sending reservation_closed mail' do
        before do
          Timecop.travel event.reservation_end + 1.hour do
            click_on_event
            click_on 'Bearbeitungsabschlussmail verschicken'
            send_and_open_email active_seller_with_reservation.email
          end
        end

        it 'shows notification of sent mail' do
          expect(page).to have_content 'Es wird eine Benachrichtigung verschickt.'
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
          its(:body) { is_expected.to have_link 'Zum geschützten Bereich' }

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
        before { Timecop.travel event.reservation_end - 1.hour }

        after { Timecop.return }

        it 'does not allow to send closed mail' do
          click_on_event
          expect(page).not_to have_link 'Bearbeitungsabschlussmail verschicken'
        end
      end

      context 'when closed mail was sent already' do
        let!(:message) { create :reservation_closed_message, event: event }

        it 'does not allow to send closed mail' do
          click_on_event
          expect(page).not_to have_link 'Bearbeitungsabschlussmail verschicken'
        end
      end

      describe 'finished mail' do
        context 'when event has not passed yet' do
          it 'does not allow to send mail' do
            click_on_event
            expect(page).not_to have_link 'Abschlussmail verschicken'
          end
        end
      end
    end
  end
end
