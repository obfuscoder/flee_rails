require 'rails_helper'

RSpec.describe 'admin/supporters/index' do
  let(:event) { create :event }
  let(:support_type) { create :support_type, event: event }
  let(:supporter) { create :supporter, support_type: support_type }

  before do
    assign :event, event
    assign :support_type, support_type
    assign :supporters, [supporter].paginate
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject(:output) { rendered }

    let(:supporter_path) { admin_event_support_type_supporter_path(event, support_type, supporter) }

    before { render }

    it { is_expected.to have_content supporter.seller.name }
    it { is_expected.to have_content supporter.comments }

    it { is_expected.to have_link href: new_admin_event_support_type_supporter_path(event, support_type) }
    it { is_expected.to have_link href: edit_admin_event_support_type_supporter_path(event, support_type, supporter) }
    it { is_expected.to have_css "a[data-link='#{supporter_path}']" }
    it { is_expected.to have_css '#confirm-modal' }
    it { is_expected.to have_link href: admin_seller_path(supporter.seller) }
  end
end
