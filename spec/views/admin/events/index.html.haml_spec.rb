# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/events/index' do
  before do
    assign :events, [create(:event)].paginate
  end
  it_behaves_like 'a standard view'
end
