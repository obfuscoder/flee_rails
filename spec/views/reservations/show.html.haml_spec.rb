require 'rails_helper'

RSpec.describe "reservations/show", :type => :view do
  before(:each) do
    @reservation = assign(:reservation, FactoryGirl.create(:reservation))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Eventname/)
    expect(rendered).to match(/Firstname Lastname/)
    expect(rendered).to match(/1/)
  end
end
