require 'rails_helper'

RSpec.describe 'admin/events/show' do
  before { assign :event, FactoryGirl.build(:event, id: 1) }
  it_behaves_like 'a standard view'

  context 'with direct event' do
    before { assign :event, FactoryGirl.build(:direct_event, id: 1) }
    it_behaves_like 'a standard view'
  end
end
