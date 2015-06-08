require 'rails_helper'

RSpec.describe 'labels/index' do
  before do
    items = assign(:items, [FactoryGirl.build(:item)])
    @event = items.first.reservation.event
  end

  it_behaves_like 'a standard view'
end
