# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reservations' do
  let(:seller) { create :seller, client: Client.first }
  let(:event) { create :event, client: Client.first }

  it 'seller tries to get reservation for event' do
    visit login_seller_path(seller.token, goto: :reserve, event: event)
    expect(page).to have_content 'Die Reservierung ist noch nicht freigeschaltet.'
  end
end
