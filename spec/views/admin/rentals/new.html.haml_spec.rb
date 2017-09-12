# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/rentals/new' do
  let(:hardware) { create_list :hardware, 3 }
  before do
    assign :event, create(:event)
    assign :hardware, hardware
    assign :rental, Rental.new
  end
  it_behaves_like 'a standard view'

  describe 'rendered' do
    before { render }
    subject { rendered }

    it { is_expected.to have_content hardware.first.description }

    it { is_expected.to have_field 'Anzahl' }
  end
end
