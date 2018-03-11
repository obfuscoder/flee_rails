# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples_for_views'

RSpec.describe 'sellers/show' do
  let!(:seller) { assign :seller, create(:seller, reservations: reservations) }
  let(:reservations) { [reservation].compact }
  let!(:events) { assign :events, [event].compact }
  let(:reservation) {}
  let(:event) {}
  let(:preparations) {}

  it_behaves_like 'a standard view'

  before do
    preparations
    render
  end

  it 'shows seller information' do
    expect(rendered).to have_content seller.first_name
    expect(rendered).to have_content seller.last_name
    expect(rendered).to have_content seller.street
    expect(rendered).to have_content seller.zip_code
    expect(rendered).to have_content seller.city
    expect(rendered).to have_content seller.email
    expect(rendered).to have_content seller.phone
  end

  it 'links to edit_seller_path' do
    expect(rendered).to have_link href: edit_seller_path
  end

  context 'with event' do
    let(:event) { create :event_with_ongoing_reservation }
    it 'links to reservation' do
      expect(rendered).to have_link href: event_reservations_path(event)
    end
    it 'shows number of reservations left and max sellers' do
      expect(rendered).to have_content "#{event.reservations_left} von #{event.max_reservations} Plätzen frei"
    end

    context 'when seller is suspended' do
      let(:preparations) { create :suspension, event: event, seller: seller }
      it 'shows number of reservations left and max sellers' do
        expect(rendered).to have_content "#{event.reservations_left} von #{event.max_reservations} Plätzen frei"
      end

      it 'does not link to reservation' do
        expect(rendered).not_to have_link href: event_reservations_path(event)
      end
    end

    context 'when event is full' do
      let(:event) { create :full_event }
      it 'does not link to reservation' do
        expect(rendered).not_to have_link href: event_reservations_path(event)
      end
      context 'when seller is not notified yet' do
        it 'links to notification' do
          expect(rendered).to have_link href: event_notification_path(event)
        end

        context 'when seller is suspended for that event' do
          let(:preparations) { create :suspension, event: event, seller: seller }
          it 'does not link to notification' do
            expect(rendered).not_to have_link href: event_notification_path(event)
          end
        end
      end
      context 'when seller is notified already' do
        let(:notification) { build :notification, seller: seller }
        let(:event) { create :full_event, notifications: [notification] }
        it 'does not link to notification' do
          expect(rendered).not_to have_link href: event_notification_path(event)
        end

        it 'shows position on notification list' do
          expect(rendered).to have_content 'Position 1'
        end
      end
    end
  end

  context 'with reservation' do
    let(:reservation) { create :reservation }

    it_behaves_like 'a standard view'

    it 'shows event name' do
      expect(rendered).to have_content reservation.event.name
    end

    it 'shows event date' do
      expect(rendered).to have_content view.shopping_time(reservation.event)
    end

    it 'shows reservation number' do
      expect(rendered).to match(/#{reservation.number}/)
    end

    it 'links to item index page' do
      expect(rendered).to have_link href: event_reservation_items_path(reservation.event, reservation)
    end

    context 'with reservation phase ongoing' do
      it 'allows deletion of reservation' do
        expect(rendered).to have_link href: event_reservation_path(reservation.event, reservation)
      end

      it 'does not link to event statistics page' do
        expect(rendered).not_to have_link href: event_path(reservation.event)
      end

      it 'does not link to new event review page' do
        expect(rendered).not_to have_link href: new_event_reservation_review_path(reservation.event, reservation)
      end

      context 'with event kind commissioned' do
        let(:reservation) { create :ongoing_reservation_for_commission_event }

        it 'shows date until labels need to be created' do
          expect(rendered).to match(/#{l(reservation.event.reservation_end, format: :long)}/)
        end
      end
      context 'with event kind direct' do
        let(:reservation) { create :ongoing_reservation_for_direct_event }

        it 'does not show reservation end date' do
          expect(rendered).not_to match(/#{l(reservation.event.reservation_end, format: :long)}/)
        end
      end
    end

    context 'with event date passed' do
      let(:preparations) { Timecop.travel reservation.event.shopping_periods.first.max + 1.hour }
      after { Timecop.return }

      it 'does not show reservation end date' do
        expect(rendered).not_to match(/#{l(reservation.event.reservation_end, format: :long)}/)
      end

      context 'without review' do
        it 'links to new event review page' do
          expect(rendered).to have_link href: new_event_reservation_review_path(reservation.event, reservation)
        end
      end

      context 'with review' do
        let(:reservation) { create(:reservation).tap(&:build_review) }
        it 'does not link to new event review page' do
          expect(rendered).not_to have_link href: new_event_reservation_review_path(reservation.event, reservation)
        end
      end

      it 'links to event results page' do
        expect(rendered).to have_link href: event_path(reservation.event)
      end
    end

    context 'with reservation phase passed and event upcoming' do
      let(:preparations) { Timecop.travel reservation.event.reservation_end + 1.hour }
      after { Timecop.return }

      it 'does not show reservation end date' do
        expect(rendered).not_to match(/#{l(reservation.event.reservation_end, format: :long)}/)
      end

      it 'does not link to event statistics page' do
        expect(rendered).not_to have_link href: event_path(reservation.event)
      end

      it 'does not link to new event review page' do
        expect(rendered).not_to have_link href: new_event_reservation_review_path(reservation.event, reservation)
      end
    end
  end
end
