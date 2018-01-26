# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/events/show' do
  let(:event) { create :event }
  before { assign :event, event }
  it_behaves_like 'a standard view'

  context 'with direct event' do
    let(:event) { create :direct_event }
    it_behaves_like 'a standard view'
  end

  describe 'rendered' do
    let(:preparation) {}
    before do
      preparation
      render
    end
    subject { rendered }

    it { is_expected.to have_content event.token }
    it { is_expected.to have_link 'Statistiken', href: stats_admin_event_path(event) }

    it do
      is_expected.not_to have_link 'Bearbeitungsabschlussmail verschicken',
                                   href: admin_event_messages_path(event, :reservation_closed)
    end

    it { is_expected.to have_link 'Daten herunterladen' }

    it { is_expected.to have_link 'Sperren', href: admin_event_suspensions_path(event) }

    it { is_expected.to have_link 'Leihgeräte', href: admin_event_rentals_path(event) }

    context 'when reservation end has past' do
      let(:additional_preparation) {}
      let(:preparation) do
        additional_preparation
        event.update reservation_end: 1.hour.ago
      end
      it do
        is_expected.to have_link 'Bearbeitungsabschlussmail verschicken',
                                 href: admin_event_messages_path(event, :reservation_closed)
      end

      context 'when reservation closed mail was triggered' do
        let(:additional_preparation) { create :reservation_closed_message, event: event }
        it { is_expected.to have_link 'Daten herunterladen', href: data_admin_event_path(event, format: :json) }
        it do
          is_expected.not_to have_link 'Bearbeitungsabschlussmail verschicken',
                                       href: admin_event_messages_path(event, :reservation_closed)
        end
      end
    end
  end
end
