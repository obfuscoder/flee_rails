require 'rails_helper'
require 'support/shared_examples_for_views'

RSpec.describe 'sellers/show' do
  let!(:seller) do
    assign :seller, FactoryGirl.create(:seller,
                                       reservations: reservation ? [reservation] : [],
                                       reviews: review ? [review] : [])
  end
  let!(:events) { assign :events, event ? [event] : [] }
  let(:reservation) {}
  let(:review) {}
  let(:event) {}

  it_behaves_like 'a standard view'

  before do
    render
  end

  it 'links to items_path' do
    assert_select 'a[href=?]', items_path
  end

  it 'shows seller information' do
    expect(rendered).to match(/#{seller.first_name}/)
    expect(rendered).to match(/#{seller.last_name}/)
    expect(rendered).to match(/#{seller.street}/)
    expect(rendered).to match(/#{seller.zip_code}/)
    expect(rendered).to match(/#{seller.city}/)
    expect(rendered).to match(/#{seller.email}/)
    expect(rendered).to match(/#{seller.phone}/)
  end

  it 'links to edit_seller_path' do
    assert_select 'a[href=?]', edit_seller_path
  end

  context 'with event' do
    let(:event) { FactoryGirl.create :event_with_ongoing_reservation }
    it 'links to reservation' do
      assert_select 'a[href=?][data-method=?]', event_reservation_path(event), 'post'
    end
    context 'when event is full' do
      let(:event) { FactoryGirl.create :full_event }
      it 'does not link to reservation' do
        assert_select 'a[href=?][data-method=?]', event_reservation_path(event), 'post', 0
      end
      context 'when seller is not notified yet' do
        it 'links to notification' do
          assert_select 'a[href=?][data-method=?]', event_notification_path(event), 'post'
        end
      end
      context 'when seller is notified already' do
        let(:notification) { FactoryGirl.build :notification, seller: seller }
        let(:event) { FactoryGirl.create :full_event, notifications: [notification] }
        it 'does not link to notification' do
          assert_select 'a[href=?][data-method=?]', event_notification_path(event), 'post', 0
        end
      end
    end
  end

  context 'with reservation' do
    let(:reservation) { FactoryGirl.create :reservation }

    it_behaves_like 'a standard view'

    it 'shows event name' do
      expect(rendered).to match(/#{reservation.event.name}/)
    end

    it 'shows event date' do
      expect(rendered).to match(/#{l(reservation.event.shopping_start.to_date, format: :long)}/)
    end

    it 'shows reservation number' do
      expect(rendered).to match(/#{reservation.number}/)
    end

    context 'with reservation phase ongoing' do
      let(:reservation) { FactoryGirl.create :ongoing_reservation }

      it 'allows deletion of reservation' do
        assert_select 'a[href=?][data-method=?]', event_reservation_path(reservation), 'delete'
      end

      it 'does not link to event statistics page' do
        assert_select 'a[href=?]', event_path(reservation.event), 0
      end

      it 'does not link to new event review page' do
        assert_select 'a[href=?]', new_event_review_path(reservation.event), 0
      end

      context 'with event kind commission' do
        let(:reservation) { FactoryGirl.create :ongoing_reservation_for_commission_event }

        it 'shows date until labels need to be created' do
          expect(rendered).to match(/#{l(reservation.event.reservation_end, format: :long)}/)
        end
      end
      context 'with event kind direct' do
        let(:reservation) { FactoryGirl.create :ongoing_reservation_for_direct_event }

        it 'does not show reservation end date' do
          expect(rendered).not_to match(/#{l(reservation.event.reservation_end, format: :long)}/)
        end
      end
    end

    context 'with event date passed' do
      Event.kinds.keys.each do |kind|
        context "with #{kind} event" do
          let(:reservation) { FactoryGirl.create :reservation_with_passed_event, kind: kind }

          it 'does not show reservation end date' do
            expect(rendered).not_to match(/#{l(reservation.event.reservation_end, format: :long)}/)
          end

          context 'without review' do
            it 'links to new event review page' do
              assert_select 'a[href=?]', new_event_review_path(reservation.event)
            end
          end

          context 'with review' do
            let(:review) { FactoryGirl.create :review, event: reservation.event }

            it 'does not link to new event review page' do
              assert_select 'a[href=?]', new_event_review_path(reservation.event), 0
            end
          end

          it 'links to event statistics page' do
            assert_select 'a[href=?]', event_path(reservation.event)
          end
        end
      end
    end

    context 'with reservation phase passed and event upcoming' do
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
