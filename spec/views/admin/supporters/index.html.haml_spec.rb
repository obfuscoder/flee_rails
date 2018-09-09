# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/supporters/index' do
  let(:event) { create :event }
  let(:support_type) { create :support_type, event: event }
  let(:supporter) { create :supporter, support_type: support_type }

  before do
    assign :event, event
    assign :support_type, support_type
    assign :supporters, [supporter]
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject(:output) { rendered }

    before { render }

    it { is_expected.to have_content supporter.seller.name }
    it { is_expected.to have_content supporter.comments }

    it { is_expected.to have_link href: new_admin_event_support_type_supporter_path(event, support_type) }
    it { is_expected.to have_link href: edit_admin_event_support_type_supporter_path(event, support_type, supporter) }
    it { is_expected.to have_link href: admin_event_support_type_supporter_path(event, support_type, supporter) }
    it { is_expected.to have_link href: admin_seller_path(supporter.seller) }
  end
end
