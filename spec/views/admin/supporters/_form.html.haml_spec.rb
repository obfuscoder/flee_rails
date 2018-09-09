# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/supporters/_form' do
  let(:event) { create :event }
  let(:support_type) { create :support_type, event: event }
  let(:supporter) { build :supporter, support_type: support_type }

  before do
    assign :event, event
    assign :support_type, support_type
    assign :supporter, supporter
  end

  it_behaves_like 'a standard partial'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_field 'supporter_seller_id' }
    it { is_expected.to have_field 'supporter_comments' }
  end
end
