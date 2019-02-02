# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'labels/index' do
  before do
    items = assign(:items, [create(:item)])
    @event = items.first.reservation.event
    @reservation = items.first.reservation
  end

  it_behaves_like 'a standard view'
end
