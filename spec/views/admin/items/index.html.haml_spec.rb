# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/items/index' do
  let(:event) { create :event_with_ongoing_reservation }
  let(:reservation) { create :reservation, event: event }
  let(:item) { create :item, reservation: reservation }
  let(:item_with_code) { create :item_with_code, reservation: reservation }

  before do
    assign :reservation, reservation
    assign :items, [item, item_with_code]
  end

  it_behaves_like 'a standard view'

  it 'renders price in Euro' do
    render
    expect(rendered).to have_content '1,90 €'
  end

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_css "a[data-link='#{admin_reservation_item_path(reservation, item)}']" }
    it { is_expected.to have_css '#confirm-modal' }
    it { is_expected.not_to have_link 'Etikett freigeben', href: code_admin_reservation_item_path(reservation, item) }
    it do
      is_expected.to have_link 'Etikett freigeben', href: code_admin_reservation_item_path(reservation, item_with_code)
    end

    it { is_expected.to have_link 'Alle Etiketten freigeben', href: codes_admin_reservation_items_path(reservation) }

    it { is_expected.to have_link 'Artikel hinzufügen', href: new_admin_reservation_item_path(reservation) }

    it { is_expected.to have_link 'Bearbeiten', href: edit_admin_reservation_item_path(reservation, item) }

    it { is_expected.not_to have_text 'Spende wenn nicht verkauft' }

    it { is_expected.to have_link 'Etiketten drucken', href: labels_admin_reservation_items_path(reservation) }

    context 'when donation is enabled for event' do
      let(:event) { create :event_with_ongoing_reservation, donation_of_unsold_items_enabled: true }

      it { is_expected.to have_text 'Spende wenn nicht verkauft' }
    end
  end
end
