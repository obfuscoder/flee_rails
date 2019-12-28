require 'rails_helper'

RSpec.describe 'admin/reservations/edit' do
  let(:reservation) { create :reservation }

  before do
    assign :event, reservation.event
    assign :reservation, reservation
  end

  it_behaves_like 'a standard view'
end
