require 'rails_helper'
require 'support/shared_examples_for_views'

RSpec.describe 'sellers/show' do
  let!(:seller) { assign :seller, FactoryGirl.build(:seller, reservations: reservation ? [reservation] : []) }
  let!(:events) { assign :events, event ? [event] : [] }
  let(:reservation) {}
  let(:event) {}

  it_behaves_like 'a standard view'

  before do
    render
  end

  it 'links to items_path' do
    assert_select "a[href=?]", items_path
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
    assert_select "a[href=?]", edit_seller_path
  end

  context 'with event' do
    let(:event) { FactoryGirl.create :event_with_ongoing_reservation }
    it 'links to reservation' do
      assert_select 'a[href=?][data-method=?]', event_reservations_path(event), 'post'
    end
    context 'when event is full' do
      let(:event) { FactoryGirl.create :full_event }
      it 'does not link to reservation' do
        assert_select 'a[href=?][data-method=?]', event_reservations_path(event), 'post', 0
      end
      context 'when seller is not notified yet' do
        it 'links to notification'
      end
      context 'when seller is notified' do
        it 'does not link to notification'
      end
    end
  end

  context 'with reservation' do
    let(:reservation) { FactoryGirl.create :reservation }

    it_behaves_like 'a standard view'

    it 'shows event name' do
      expect(rendered).to match /#{reservation.event.name}/
    end

    it 'shows event date' do
      expect(rendered).to match /#{l(reservation.event.shopping_start.to_date, format: :long)}/
    end

    it 'shows reservation number' do
      expect(rendered).to match /<strong>#{reservation.number}<\/strong>/
    end

    context 'with reservation phase ongoing' do
      it 'allows deletion of reservation' do
        assert_select 'a[href=?][data-method=?]', reservation_path(reservation), 'delete'
      end

      it 'does not link to event statistics page'
      it 'does not link to event review page'

      context 'with type commission' do
        it 'shows date until labels need to be created' do
          expect(rendered).to match /#{l(reservation.event.reservation_end, format: :long)}/
        end
      end
      context 'with type direct' do
        it 'does not show reservation end date'
      end
    end

    context 'with event date passed' do
      it 'does not show reservation end date'
      it 'links to event statistics page'
      it 'links to event review page'
    end

    context 'with reservation phase passed and event upcoming' do
      it 'does not show reservation end date'
      it 'does not link to event statistics page'
      it 'does not link to event review page'
    end
  end
end
