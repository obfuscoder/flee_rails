require 'rails_helper'

RSpec.describe 'admin/events/stats' do
  let(:event) do
    double id: 1,
           max_sellers: 13,
           item_count: 10,
           items_with_label_count: 8,
           sold_item_count: 6,
           items_per_category: [
             ['Cat1', 5],
             ['Cat2', 2]
           ],
           reservations: double(count: 12),
           notifications: [
             double(seller: double(name: 'Name1')),
             double(seller: double(name: 'Name2'))
           ]
  end
  before { assign :event, event }
  it_behaves_like 'a standard view'

  describe 'rendered' do
    before { render }
    subject { rendered }
    it { is_expected.to have_content event.item_count }
    it { is_expected.to have_content event.items_with_label_count }
    it { is_expected.to have_content event.sold_item_count }

    {
      items_per_category_for_event: :items_per_category_admin_event_path
    }.each do |element, path_method|
      it { is_expected.to have_css "##{element}[data-url='#{send(path_method, event.id)}']" }
    end

    it { is_expected.to have_link 'Tabelle anzeigen', href: '#items_per_category_table_collapser' }
    it { is_expected.to have_css '.collapse#items_per_category_table_collapser' }
    it { is_expected.to have_css '#items_per_category_table' }
    it 'lists all categories' do
      event.items_per_category.each do |category_name, item_count|
        is_expected.to have_content category_name
        is_expected.to have_content item_count
      end
    end

    it { is_expected.to have_content "#{event.reservations.count} / #{event.max_sellers}" }
    it { is_expected.to have_content event.notifications.count }

    it { is_expected.to have_link 'anzeigen', href: '#notifications_collapser' }
    it { is_expected.to have_css '.collapse#notifications_collapser' }

    it 'lists all seller names of the notifications' do
      event.notifications.each { |notification| is_expected.to have_content notification.seller.name }
    end
  end
end
