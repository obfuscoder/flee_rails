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
    assert_select 'a[href=?]', edit_seller_path
  end

  context 'with event' do
    let(:event) { create :event_with_ongoing_reservation }
    it 'links to reservation' do
      assert_select 'a[href=?][data-method=?]', event_reservations_path(event), 'post'
    end
    it 'shows number of reservations left and max sellers' do
      expect(rendered).to have_content "#{event.reservations_left} von #{event.max_sellers} Plätzen frei"
    end
    context 'when event is full' do
      let(:event) { create :full_event }
      it 'does not link to reservation' do
        assert_select 'a[href=?][data-method=?]', event_reservations_path(event), 'post', 0
      end
      context 'when seller is not notified yet' do
        it 'links to notification' do
          assert_select 'a[href=?][data-method=?]', event_notification_path(event), 'post'
        end
      end
      context 'when seller is notified already' do
        let(:notification) { build :notification, seller: seller }
        let(:event) { create :full_event, notifications: [notification] }
        it 'does not link to notification' do
          assert_select 'a[href=?][data-method=?]', event_notification_path(event), 'post', 0
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
      expect(rendered).to have_link 'Artikel bearbeiten',
                                    href: event_reservation_items_path(reservation.event, reservation)
    end

    context 'with reservation phase ongoing' do
      it 'allows deletion of reservation' do
        assert_select 'a[href=?][data-method=?]', event_reservation_path(reservation.event, reservation), 'delete'
      end

      it 'does not link to event statistics page' do
        assert_select 'a[href=?]', event_path(reservation.event), 0
      end

      it 'does not link to new event review page' do
        assert_select 'a[href=?]', new_event_review_path(reservation.event), 0
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
          assert_select 'a[href=?]', new_event_review_path(reservation.event)
        end
      end

      context 'with review' do
        let(:reservation) do
          create(:reservation).tap do |reservation|
            reservation.build_review
          end
        end
        it 'does not link to new event review page' do
          assert_select 'a[href=?]', new_event_review_path(reservation.event), 0
        end
      end

      it 'links to event results page' do
        assert_select 'a[href=?]', event_path(reservation.event)
      end
    end

    context 'with reservation phase passed and event upcoming' do
      let(:preparations) { Timecop.travel reservation.event.reservation_end + 1.hour }
      after { Timecop.return }

      it 'does not show reservation end date' do
        expect(rendered).not_to match(/#{l(reservation.event.reservation_end, format: :long)}/)
      end

      it 'does not link to event statistics page' do
        assert_select 'a[href=?]', event_path(reservation.event), 0
      end

      it 'does not link to new event review page' do
        assert_select 'a[href=?]', new_event_review_path(reservation.event), 0
      end
    end
  end
end
