require 'rails_helper'

RSpec.describe "reservations/show", :type => :view do
  before(:each) do
    @reservation = assign(:reservation, Reservation.create!(
      :seller => nil,
      :event => nil,
      :number => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
  end
end
