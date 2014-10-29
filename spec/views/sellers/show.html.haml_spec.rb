require 'rails_helper'
require 'support/shared_examples_for_views'

RSpec.describe 'sellers/show' do
  let!(:seller) { assign :seller, FactoryGirl.create(:seller) }

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

  context 'with reservations' do
    let!(:reservations) { (0..2).map { FactoryGirl.create :reservation, seller: seller } }
    xit 'links to destroy_reservation' do
      reservations.each do |reservation|
        assert_select 'form[action=?][method=?]', reservation_path(reservation), 'delete'
      end
    end
  end
end
