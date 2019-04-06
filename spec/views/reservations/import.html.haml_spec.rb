# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'reservations/import' do
  subject { rendered }

  let(:seller) { create :seller }
  let(:event) { create :event_with_ongoing_reservation }
  let(:reservation) { create :reservation, event: event, seller: seller }
  let(:previous_reservation) do
    Timecop.freeze 1.year.ago do
      create :reservation, seller: seller
    end
  end
  let(:reservations) { [previous_reservation] }

  before do
    assign :event, event
    assign :reservation, reservation
    assign :reservations, reservations
    render
  end

  it_behaves_like 'a standard view'

  it { is_expected.to have_link href: event_reservation_items_path(event, reservation) }
  it { is_expected.to have_link href: event_reservation_import_from_path(event, reservation, previous_reservation) }
end
