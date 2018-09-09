# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples_for_views'

RSpec.describe 'events/show' do
  let(:event) { create :event_with_ongoing_reservation }
  let(:reservation) { create :reservation, event: event }
  let!(:items) { create_list :item, 4, reservation: reservation }
  let!(:sold_items) { create_list :sold_item, 6, reservation: reservation }

  before do
    assign :event, event
    render
  end

  it_behaves_like 'a standard view'

  describe 'rendered' do
    subject { rendered }

    it { is_expected.to have_content shopping_time(event) }
    it { is_expected.to have_content items.count + sold_items.count }
    it { is_expected.to have_content sold_items.count }
    it { is_expected.to have_content '60%' }
  end
end
