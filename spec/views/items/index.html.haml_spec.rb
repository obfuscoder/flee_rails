# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'items/index' do
  subject { rendered }

  let(:event) { create :event_with_ongoing_reservation }
  let(:seller) { create :seller }
  let(:reservation) { create :reservation, seller: seller, event: event }
  let(:items) { create_list(:item, 50, reservation: reservation) }
  let(:preparations) {}
  let(:client_setup) {}

  before do
    client_setup
    preparations
    assign :items, items.paginate(page: 2)
    assign :seller, seller
    assign :event, reservation.event
    assign :reservation, reservation
    allow_any_instance_of(ApplicationHelper).to receive(:sort_link_to) { |_, cls, attribute| "#{cls}.#{attribute}" }
    render
  end

  it_behaves_like 'a standard view'

  it 'shows prices in €' do
    expect(rendered).to have_content '1,90 €'
  end

  it { is_expected.to have_link 'Zurück' }
  it { is_expected.to have_text 'Weiter' }

  context 'when item with label exists' do
    let(:items) { create_list :item_with_code, 50, reservation: reservation }

    it { is_expected.to have_link 'Etikett freigeben' }
  end

  it 'does not show donation column' do
    expect(rendered).not_to have_text 'Item.donation'
  end

  context 'when donation is enabled for the event' do
    let(:event) { create :event_with_ongoing_reservation, donation_of_unsold_items_enabled: true }

    it 'shows donation column' do
      expect(rendered).to have_text 'Item.donation'
    end
  end

  context 'with unsold items of reservation for previous event' do
    let(:preparations) do
      Timecop.freeze 1.year.ago do
        previous_items
        previous_sold_items
      end
    end
    let(:previous_event) { create :event_with_ongoing_reservation }
    let(:previous_reservation) { create :reservation, seller: seller, event: previous_event }
    let(:previous_items) { create_list :item_with_code, 5, reservation: previous_reservation }
    let(:previous_sold_items) { create_list :sold_item, 5, reservation: previous_reservation }

    it { is_expected.not_to have_link href: import_event_reservation_path(event, reservation) }

    context 'when item import is allowed' do
      let(:client_setup) { Client.first.update import_items_allowed: true }

      it { is_expected.to have_link href: import_event_reservation_path(event, reservation) }
    end
  end
end
