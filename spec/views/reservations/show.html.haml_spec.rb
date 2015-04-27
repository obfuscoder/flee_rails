require 'rails_helper'

RSpec.describe 'reservations/show' do
  before(:each) do
    @reservation = assign(:reservation, FactoryGirl.create(:reservation))
    render
  end

  it_behaves_like 'a standard view'

  it 'renders attributes in <p>' do
    expect(rendered).to match(/#{@reservation.event.name}/)
    expect(rendered).to match(/Firstname Lastname/)
    expect(rendered).to match(/1/)
  end
end
