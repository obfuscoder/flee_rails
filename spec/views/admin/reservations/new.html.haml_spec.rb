require 'rails_helper'

RSpec.describe 'admin/reservations/new' do
  let(:seller) { create :seller }
  let(:event) { create :event }

  before do
    assign :sellers, [seller]
    assign :event, event
    assign :reservation, event.reservations.build
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_field 'reservation_seller_id' }
    it { is_expected.to have_field 'reservation_number' }
    it { is_expected.to have_field 'reservation_commission_rate' }
    it { is_expected.to have_field 'reservation_fee' }
    it { is_expected.to have_field 'reservation_max_items' }
    it { is_expected.to have_field 'reservation_category_limits_ignored' }
  end
end
