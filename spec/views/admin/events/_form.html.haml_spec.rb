# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/events/_form' do
  before { assign :event, build(:event) }
  it_behaves_like 'a standard partial'

  context 'rendered' do
    before { render }
    subject { rendered }

    it { is_expected.to have_field 'Termin steht fest' }
    it { is_expected.to have_field 'Reservierungen pro Verkäufer' }
    it { is_expected.to have_unchecked_field 'Reservierungsgebühr wird im Voraus bezahlt' }
  end
end
