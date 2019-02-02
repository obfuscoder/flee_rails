# frozen_string_literal: true

require 'rails_helper'
require 'features/admin/login'

RSpec.describe 'admin event reservations' do
  include_context 'when logging in'
  let(:event) { create :event_with_ongoing_reservation, max_reservations: 5 }
  let!(:sellers) { create_list :seller, 4 }
  let(:number_of_reservations) { 3 }
  let!(:reservations) { create_list :reservation, number_of_reservations, event: event }

  before do
    click_on 'Termine'
    click_on 'Anzeigen'
    click_on 'Reservierungen'
  end

  describe 'new reservation' do
    shared_examples 'create reservations for selected sellers' do
      before do
        click_on 'Neue Reservierung'
        selection.each { |seller| select seller.label_for_selects, from: 'Verkäufer' }
        click_on 'Reservierung erstellen'
      end

      it 'creates reservations for selected sellers' do
        expect(page).to have_content "#{selection.count} Reservierungen erfolgreich durchgeführt"
      end
    end

    it_behaves_like 'create reservations for selected sellers' do
      let(:selection) { sellers.take(2) }
    end

    context 'when reservation limit is being reached' do
      it_behaves_like 'create reservations for selected sellers' do
        let(:selection) { sellers.take(3) }
      end
    end

    context 'when reservation period has not started yet' do
      before { Timecop.travel event.reservation_start - 1.hour }

      after { Timecop.return }

      it_behaves_like 'create reservations for selected sellers' do
        let(:selection) { sellers.take(2) }
      end
    end
  end
end
