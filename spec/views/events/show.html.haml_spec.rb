require 'rails_helper'
require 'support/shared_examples_for_views'

RSpec.describe 'events/show' do
  let(:event) { create :event }
  let(:item_count) { 10 }
  let(:sold_item_count) { 6 }

  it_behaves_like 'a standard view'

  before do
    assign :event, event
    assign :item_count, item_count
    assign :sold_item_count, sold_item_count
    render
  end

  describe 'rendered' do
    subject { rendered }
    it { is_expected.to have_content shopping_time(event) }
    it { is_expected.to have_content item_count }
    it { is_expected.to have_content sold_item_count }
    it { is_expected.to have_content '60%' }
    it { is_expected.to have_css "#canvas_top_sellers[data-url='#{top_sellers_event_path(event.id)}']" }
  end
end
