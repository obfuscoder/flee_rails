# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/suspensions/edit' do
  let(:suspension) { create :suspension }

  before do
    assign :event, suspension.event
    assign :suspension, suspension
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_field 'Grund' }
  end
end
