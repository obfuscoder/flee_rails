require 'rails_helper'

RSpec.describe 'labels/index' do
  before(:each) do
    assign(:item, FactoryGirl.build(:item))
  end

  it_behaves_like 'a standard view'
end
