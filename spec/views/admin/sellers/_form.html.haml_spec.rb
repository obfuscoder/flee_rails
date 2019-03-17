# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/sellers/_form' do
  let(:seller) { build :seller }

  before { assign :seller, seller }

  it_behaves_like 'a standard partial'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_field 'seller_first_name' }
    it { is_expected.to have_field 'seller_last_name' }
    it { is_expected.to have_field 'seller_street' }
    it { is_expected.to have_field 'seller_zip_code' }
    it { is_expected.to have_field 'seller_city' }
    it { is_expected.to have_field 'seller_phone' }
    it { is_expected.to have_field 'seller_email' }
    it { is_expected.to have_field 'seller_default_reservation_number' }
  end
end
