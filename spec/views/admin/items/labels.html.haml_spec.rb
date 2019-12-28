require 'rails_helper'

RSpec.describe 'admin/items/labels' do
  let(:reservation) { create :reservation }
  let(:items) { create_list :item, 5, reservation: reservation }

  before do
    assign :items, items
    assign :reservation, reservation
  end

  it_behaves_like 'a standard view'
end
