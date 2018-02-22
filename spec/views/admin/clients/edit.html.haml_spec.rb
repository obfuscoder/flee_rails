# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/clients/edit' do
  before { assign :client, build(:client) }
  it_behaves_like 'a standard view'

  context 'rendered' do
    before { render }
    subject { rendered }

    it { is_expected.to have_field 'client_name' }
    it { is_expected.to have_field 'client_short_name' }
    it { is_expected.to have_field 'client_address' }
    it { is_expected.to have_field 'client_invoice_address' }
    it { is_expected.to have_field 'client_intro' }
    it { is_expected.to have_field 'client_outro' }
    it { is_expected.to have_field 'client_terms' }
    it { is_expected.to have_field 'client_reservation_fee' }
    it { is_expected.to have_field 'client_commission_rate' }
    it { is_expected.to have_field 'client_price_precision' }
    it { is_expected.to have_field 'client_donation_of_unsold_items' }
    it { is_expected.to have_field 'client_donation_of_unsold_items_default' }
    it { is_expected.to have_field 'client_reservation_by_seller_forbidden' }
  end
end
