# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/reservations/_form' do
  before { assign :reservation, build(:reservation) }

  it_behaves_like 'a standard partial'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_field 'reservation_commission_rate' }
    it { is_expected.to have_field 'reservation_fee' }
    it { is_expected.to have_field 'reservation_max_items' }
    it { is_expected.to have_field 'reservation_category_limits_ignored' }
  end
end
