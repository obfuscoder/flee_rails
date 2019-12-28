require 'rails_helper'

RSpec.describe 'admin/rentals/edit' do
  let(:rental) { create :rental }

  before do
    assign :event, rental.event
    assign :rental, rental
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_field 'Anzahl' }
  end
end
