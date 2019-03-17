# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/sellers/_form' do
  let(:seller) { build :seller }
  let(:preparations) {}

  before do
    preparations
    assign :seller, seller
  end

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
    it { is_expected.not_to have_field 'seller_default_reservation_number' }

    context 'when Client#auto_reservation_numbers_start is configured' do
      let(:preparations) { Client.first.update! auto_reservation_numbers_start: 100 }

      it { is_expected.to have_field 'seller_default_reservation_number' }
    end
  end
end
