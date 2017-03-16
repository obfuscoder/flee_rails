require 'rails_helper'

RSpec.describe 'admin/reservations/_form' do
  before { assign :reservation, build(:reservation) }
  it_behaves_like 'a standard partial'

  context 'rendered' do
    before { render }
    subject { rendered }
  end
end
