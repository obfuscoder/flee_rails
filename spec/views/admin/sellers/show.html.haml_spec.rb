# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/sellers/show' do
  before { Client.first.update! auto_reservation_numbers_start: 400 }

  let(:seller) { create :seller, default_reservation_number: default_reservation_number }
  let(:default_reservation_number) { 123 }
  let!(:reservation) { create :reservation, seller: seller }
  let!(:supporter) { create :supporter, seller: seller }

  before { assign :seller, seller }

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_content seller.name }
    it { is_expected.to have_content seller.street }
    it { is_expected.to have_content seller.zip_code }
    it { is_expected.to have_content seller.city }
    it { is_expected.to have_content seller.phone }
    it { is_expected.to have_content seller.email }
    it { is_expected.to have_content reservation.number }
    it { is_expected.to have_content reservation.event.name }
    it { is_expected.to have_link href: admin_event_path(reservation.event) }
    it { is_expected.to have_link href: admin_reservation_items_path(reservation) }
    it { is_expected.to have_content supporter.comments }
    it { is_expected.to have_content supporter.support_type.name }
    it { is_expected.to have_content supporter.support_type.event.name }
    it { is_expected.to have_link href: admin_event_path(supporter.support_type.event) }
    it do
      is_expected.to have_link href: admin_event_support_type_supporters_path(supporter.support_type.event,
                                                                              supporter.support_type)
    end
    it { is_expected.to have_link href: edit_admin_seller_path(seller) }
    it { is_expected.to have_content default_reservation_number }
  end
end
