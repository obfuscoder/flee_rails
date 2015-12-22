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
    {
      canvas_top_sellers: :top_sellers_event_path,
      items_per_category_for_event: :items_per_category_event_path,
      sold_items_per_category_for_event: :sold_items_per_category_event_path,
      sellers_per_city: :sellers_per_city_event_path
    }.each do |element, path_method|
      it { is_expected.to have_css "##{element}[data-url='#{send(path_method, event.id)}']" }
    end
  end
end
