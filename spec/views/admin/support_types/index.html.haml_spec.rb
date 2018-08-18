# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/support_types/index' do
  let(:event) { create :event }
  let(:support_type) { create :support_type, event: event }
  before do
    assign :support_types, [support_type]
    assign :event, event
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    before { render }
    subject(:output) { rendered }

    it { is_expected.to have_content support_type.name }
    it { is_expected.to have_content support_type.capacity }

    it { is_expected.to have_link href: new_admin_event_support_type_path(event) }
    it { is_expected.to have_link href: edit_admin_event_support_type_path(event, support_type) }
    it { is_expected.to have_link href: admin_event_support_type_path(event, support_type) }
    it { is_expected.to have_link href: admin_event_support_type_supporters_path(event, support_type) }
    it { is_expected.to have_link href: print_admin_event_support_types_path(event) }
  end
end
