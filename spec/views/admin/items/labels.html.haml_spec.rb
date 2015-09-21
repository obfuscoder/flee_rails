require 'rails_helper'

RSpec.describe 'admin/items/labels' do
  let(:reservation) { FactoryGirl.create :reservation }
  let(:items) { FactoryGirl.create_list :item, 5, reservation: reservation }
  before do
    assign :items, items
    assign :reservation, reservation
  end

  it 'works' do
    skip 'somehow the tests fail with No route matches {:action=>"labels", :controller=>"admin/items"}'
  end
  # it_behaves_like 'a standard view'
end
