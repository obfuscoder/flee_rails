require 'rails_helper'

RSpec.describe 'items/index' do
  before(:each) do
    assign(:items, [FactoryGirl.create(:item)])
    assign(:seller, FactoryGirl.create(:seller))
  end

  it_behaves_like 'a standard view'
end
