# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/suspensions/index' do
  let(:suspension) { create :suspension }
  let(:event) { suspension.event }

  before do
    assign :suspensions, [suspension].paginate
    assign :event, event
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_content suspension.reason }
    it { is_expected.to have_link 'Löschen', href: admin_event_suspension_path(event, suspension) }
    it { is_expected.to have_link 'Neue Sperre', href: new_admin_event_suspension_path(event) }
    it { is_expected.to have_link 'Bearbeiten', href: edit_admin_event_suspension_path(event, suspension) }
  end
end
