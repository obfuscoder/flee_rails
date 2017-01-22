require 'rails_helper'

RSpec.describe 'admin/reservations/index' do
  let(:reservation) { create :reservation }
  let(:event) { reservation.event }
  before do
    assign :reservations, [reservation].paginate
    assign :event, event
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    before { render }
    subject { rendered }

    it { is_expected.to have_content '20%' }
    it { is_expected.to have_content '2,00 €' }
    it { is_expected.to have_link 'Löschen', href: admin_event_reservation_path(event, reservation) }
    it { is_expected.to have_link 'Neue Reservierung', href: new_admin_event_reservation_path(event) }
    it { is_expected.to have_link 'Bearbeiten', href: edit_admin_event_reservation_path(event, reservation) }
    it { is_expected.to have_link 'Artikel', href: admin_reservation_items_path(reservation) }
  end
end
