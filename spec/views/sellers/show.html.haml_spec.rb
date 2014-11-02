require 'rails_helper'
require 'support/shared_examples_for_views'

RSpec.describe 'sellers/show' do
  let!(:seller) { assign :seller, FactoryGirl.create(:seller) }
  let!(:reservations) { assign :reservations, [] }

  before do
    render
  end

  it_behaves_like 'a standard view'

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

  context 'with open reservable events' do
    let!(:events) { assign :events, (0..2).map { FactoryGirl.create :event } }
    xit 'links to reservation' do
      events.each do |event|
        assert_select 'form[action=?][method=?]', reservations_path, 'post' do
          assert_select "input#reservation_event_id[name=?]", "reservation[event_id]", event.id
        end
      end
    end
  end

  context 'with reservation' do
    let(:reservation) { FactoryGirl.create :reservation, seller: seller }
    let!(:reservations) { r =  assign :reservations, [ reservation ]; p "reservations"; r }

    it 'shows event name and date'

    it 'shows reservation number'

    context 'with reservation phase ongoing' do
      xit 'allows deletion of reservation' do
        assert_select 'form[action=?][method=?]', reservation_path(reservation), 'delete'
      end

      it 'does not link to event statistics page'
      it 'does not link to event review page'

      context 'with type commission' do
        it 'shows date until labels need to be created'
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
