require 'rails_helper'

RSpec.describe 'admin/events/stats' do
  let(:event) { create :event_with_ongoing_reservation }
  let(:reservation) { create :reservation, event: event }
  let(:items) { create_list :item, 10, reservation: reservation }
  let!(:items_with_code) { items.take(8).each(&:create_code).each(&:save!) }
  let!(:sold_items) { items_with_code.take(6).each { |item| item.update! sold: Time.now } }
  before { assign :event, event }
  it_behaves_like 'a standard view'

  describe 'rendered' do
    before { render }
    subject { rendered }
    it { is_expected.to have_content items.count }
    it { is_expected.to have_content items_with_code.count }
    it { is_expected.to have_content sold_items.count }

    {
      items_per_category_for_event: :items_per_category_admin_event_path
    }.each do |element, path_method|
      it { is_expected.to have_css "##{element}[data-url='#{send(path_method, event.id)}']" }
    end

    it { is_expected.to have_link 'Tabelle anzeigen', href: '#items_per_category_table_collapser' }
    it { is_expected.to have_css '.collapse#items_per_category_table_collapser' }
    it { is_expected.to have_css '#items_per_category_table' }
    it 'lists all categories' do
      items.each { |item| is_expected.to have_content item.category.name }
    end
  end
end
