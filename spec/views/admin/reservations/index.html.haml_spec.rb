# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/reservations/index' do
  let(:reservation) { create :reservation }
  let(:event) { reservation.event }
  let(:preparations) {}

  before do
    preparations
    assign :reservations, [reservation].paginate
    assign :event, event
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_content '20%' }
    it { is_expected.to have_content '2,00 €' }
    it { is_expected.to have_css "a[data-link='#{admin_event_reservation_path(event, reservation)}']" }
    it { is_expected.to have_css '#confirm-modal' }
    it { is_expected.to have_link 'Neue Reservierungen', href: new_bulk_admin_event_reservations_path(event) }
    it { is_expected.to have_link 'Bearbeiten', href: edit_admin_event_reservation_path(event, reservation) }
    it { is_expected.to have_link 'Artikel', href: admin_reservation_items_path(reservation) }

    context 'when reservation numbers are assignable' do
      let(:preparations) { Client.first.update reservation_numbers_assignable: true }

      it { is_expected.to have_link 'Neue Reservierung', href: new_admin_event_reservation_path(event) }
    end
  end
end
