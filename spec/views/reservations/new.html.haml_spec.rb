require 'rails_helper'

RSpec.describe "reservations/new" do
  before(:each) do
    assign(:reservation, FactoryGirl.build(:reservation))
  end

  it "renders new reservation form" do
    render

    assert_select "form[action=?][method=?]", reservations_path, "post" do
      assert_select "select#reservation_seller_id[name=?]", "reservation[seller_id]"
      assert_select "select#reservation_event_id[name=?]", "reservation[event_id]"
      assert_select "input#reservation_number[name=?]", "reservation[number]"
    end
  end
end
