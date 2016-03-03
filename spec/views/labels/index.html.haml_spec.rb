require 'rails_helper'

RSpec.describe 'labels/index' do
  before do
    items = assign(:items, [build(:item)])
    @event = items.first.reservation.event
    @reservation = items.first.reservation
  end

  it_behaves_like 'a standard view'
end
