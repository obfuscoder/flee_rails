require 'rails_helper'

RSpec.describe 'admin/events/_form' do
  let(:event) { build :event }

  before { assign :event, event }

  it_behaves_like 'a standard partial'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_field 'event_confirmed' }
    it { is_expected.to have_field 'event_max_reservations_per_seller' }
    it { is_expected.to have_field 'event_max_items_per_reservation' }
    it { is_expected.to have_unchecked_field 'event_reservation_fees_payed_in_advance' }
    it { is_expected.to have_field 'event_support_system_enabled' }
    it { is_expected.to have_field 'event_supporters_can_retire' }
    it { is_expected.to have_field 'event_precise_bill_amounts' }
    it { is_expected.to have_field 'event_gates' }
  end
end
