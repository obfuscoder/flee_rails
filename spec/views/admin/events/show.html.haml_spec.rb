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
    subject { rendered }

    let(:preparation) {}

    before do
      preparation
      render
    end

    it { is_expected.to have_content event.token }
    it { is_expected.to have_link href: stats_admin_event_path(event) }

    it { is_expected.to have_link href: admin_event_messages_path(event, :invitation) }

    context 'when invitation mail was sent' do
      let(:preparation) { create :invitation_message, event: event, scheduled_count: 100, sent_count: 30 }

      it { is_expected.not_to have_link href: admin_event_messages_path(event, :invitation) }
      it { is_expected.to have_content '30 von 100 Reservierungseinladungen verschickt' }
    end

    it { is_expected.not_to have_link href: admin_event_messages_path(event, :reservation_closing) }

    context 'when reservation is ongoing' do
      let(:event) { create :event_with_ongoing_reservation }

      it { is_expected.to have_link href: admin_event_messages_path(event, :reservation_closing) }

      context 'when reservation closing mail was sent' do
        let(:preparation) { create :reservation_closing_message, event: event, scheduled_count: 100, sent_count: 30 }

        it { is_expected.not_to have_link href: admin_event_messages_path(event, :reservation_closing) }
        it { is_expected.to have_content '30 von 100 Erinnerungsmails vor Bearbeitungsschluss verschickt' }
      end
    end

    it { is_expected.not_to have_link href: admin_event_messages_path(event, :reservation_closed) }

    it { is_expected.to have_link href: data_admin_event_path(event, format: :json) }

    it { is_expected.to have_link href: admin_event_suspensions_path(event) }

    it { is_expected.to have_link href: admin_event_rentals_path(event) }

    it { is_expected.to have_link href: admin_event_support_types_path(event) }

    context 'when reservation end has past' do
      let(:additional_preparation) {}
      let(:preparation) do
        additional_preparation
        event.update reservation_end: 1.hour.ago
      end

      it { is_expected.to have_link href: admin_event_messages_path(event, :reservation_closed) }

      context 'when reservation closed mail was triggered' do
        let(:additional_preparation) do
          create :reservation_closed_message, event: event, scheduled_count: 80, sent_count: 10
        end

        it { is_expected.not_to have_link href: admin_event_messages_path(event, :reservation_closed) }
        it { is_expected.to have_content '10 von 80 Bearbeitungsabschlussmails verschickt' }
      end
    end
  end
end
