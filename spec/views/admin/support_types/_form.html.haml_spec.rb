# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/support_types/_form' do
  let(:event) { create :event }
  let(:support_type) { build :support_type, event: event }
  before do
    assign :event, event
    assign :support_type, support_type
  end

  it_behaves_like 'a standard partial'

  describe 'rendered' do
    before { render }
    subject { rendered }

    it { is_expected.to have_field 'support_type_name' }
    it { is_expected.to have_field 'support_type_description' }
    it { is_expected.to have_field 'support_type_capacity' }
  end
end
