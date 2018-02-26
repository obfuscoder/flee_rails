# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/reservations/new' do
  let(:seller) { create :seller }
  let(:event) { create :event }
  before do
    assign :sellers, [seller]
    assign :event, event
    assign :reservation, Reservation.new
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    before { render }
    subject { rendered }

    it { is_expected.to have_field 'reservation_seller_id' }
    it { is_expected.to have_field 'reservation_number' }
  end
end
