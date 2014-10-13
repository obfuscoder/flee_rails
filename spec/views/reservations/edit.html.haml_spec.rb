require 'rails_helper'

RSpec.describe "reservations/edit" do
  before(:each) do
    @reservation = assign(:reservation, FactoryGirl.create(:reservation))
  end

  it_behaves_like "a standard view"

  it "renders the edit reservation form" do
    render

    assert_select "form[action=?][method=?]", reservation_path(@reservation), "post" do
      assert_select "select#reservation_seller_id[name=?]", "reservation[seller_id]"
      assert_select "select#reservation_event_id[name=?]", "reservation[event_id]"
      assert_select "input#reservation_number[name=?]", "reservation[number]"
    end
  end
end
