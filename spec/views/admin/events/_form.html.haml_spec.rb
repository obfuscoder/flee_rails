# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/events/_form' do
  let(:event) { build :event }
  before do
    preparation
    assign :event, event
  end
  let(:preparation) {}
  it_behaves_like 'a standard partial'

  context 'rendered' do
    before { render }
    subject { rendered }

    it { is_expected.to have_field 'Termin steht fest' }
    it { is_expected.to have_field 'Reservierungen pro Verkäufer' }
    it { is_expected.to have_unchecked_field 'Reservierungsgebühr wird im Voraus bezahlt' }

    it { is_expected.to have_field 'event_support_system_enabled' }
  end
end
