# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Reservations' do
  let(:seller) { create :seller, client: Client.first }
  let(:event) { create :event, client: Client.first }

  scenario 'seller tries to get reservation for event' do
    visit login_seller_path(seller.token, goto: :reserve, event: event)
    expect(page).to have_content 'Die Reservierung ist noch nicht freigeschaltet.'
  end
end
