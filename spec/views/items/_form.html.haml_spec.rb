# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'items/_form' do
  let(:event) { create :event_with_ongoing_reservation }
  let(:reservation) { create :reservation, event: event }
  let(:category) { create :category }
  let(:item) { build :item, reservation: reservation, category: category }

  before do
    assign :event, event
    assign :reservation, reservation
    assign :item, item
  end

  it_behaves_like 'a standard partial'

  describe 'rendered' do
    subject { rendered }

    before { render }

    it { is_expected.to have_css "form[action='#{event_reservation_items_path(event, reservation)}']" }
    it { is_expected.to have_field 'item_category_id' }
    it { is_expected.to have_field 'item_description' }
    it { is_expected.to have_field 'item_size' }
    it { is_expected.to have_field 'item_price' }
    it { is_expected.to have_field 'item_gender_female' }
    it { is_expected.to have_field 'item_gender_male' }
    it { is_expected.to have_field 'item_gender_both' }
    it { is_expected.not_to have_field 'item_donation' }
    it { is_expected.not_to have_css '#donation-enforced-hint' }
    context 'when event donation is enabled' do
      let(:event) { create :event_with_ongoing_reservation, donation_of_unsold_items_enabled: true }

      it { is_expected.to have_field 'item_donation' }
      it { is_expected.to have_css '#donation-enforced-hint' }
    end
  end
end
