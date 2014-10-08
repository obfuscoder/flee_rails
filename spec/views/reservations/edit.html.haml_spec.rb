require 'rails_helper'

RSpec.describe "reservations/edit", :type => :view do
  before(:each) do
    @reservation = assign(:reservation, Reservation.create!(
      :seller => nil,
      :event => nil,
      :number => 1
    ))
  end

  it "renders the edit reservation form" do
    render

    assert_select "form[action=?][method=?]", reservation_path(@reservation), "post" do

      assert_select "input#reservation_seller_id[name=?]", "reservation[seller_id]"

      assert_select "input#reservation_event_id[name=?]", "reservation[event_id]"

      assert_select "input#reservation_number[name=?]", "reservation[number]"
    end
  end
end
