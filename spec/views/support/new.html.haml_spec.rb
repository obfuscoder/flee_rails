# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'support/new' do
  let(:event) { create :event_with_support }
  let(:support_type) { event.support_types.first }
  let(:supporter) { support_type.supporters.build }
  let(:seller) { create :seller }

  before do
    assign :event, event
    assign :support_type, support_type
    assign :seller, seller
    assign :supporter, supporter
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    before { render }
    subject { rendered }
    it { is_expected.to have_link href: event_support_path(event) }
    it { is_expected.to have_field 'supporter_comments' }
  end
end
