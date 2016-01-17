require 'rails_helper'

RSpec.describe 'admin/events/show' do
  let(:event) { create :event }
  before { assign :event, event }
  it_behaves_like 'a standard view'

  context 'with direct event' do
    let(:event) { create :direct_event }
    it_behaves_like 'a standard view'
  end

  describe 'rendered' do
    before { render }
    subject { rendered }

    it { is_expected.to have_content event.token }
    it { is_expected.to have_link 'Statistiken', href: stats_admin_event_path(event) }
  end
end
