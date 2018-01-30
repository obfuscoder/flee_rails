# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/events/stats' do
  let(:event) do
    double id: 1,
           max_reservations: 13,
           item_count: 10,
           items_with_label_count: 8,
           sold_item_count: 6,
           sold_item_sum: 3.5,
           reservation_fees_sum: 12.5,
           revenue: 14.5,
           rental_fees: 15,
           system_fees: 0.14,
           total_fees: 15.14,
           sold_stock_item_count: 27,
           sold_item_percentage: 60,
           items_per_category: [
             ['Cat1', 7],
             ['Cat2', 5]
           ],
           sold_items_per_category: [
             ['Cat3', 3]
           ],
           sellers_per_city: [
             ['Königsbach', 15],
             ['Leonberg', 20]
           ],
           reservations: double(count: 12),
           notifications: [
             double(seller: double(name: 'Name1', city: 'city1')),
             double(seller: double(name: 'Name2', city: 'city2'))
           ],
           sold_stock_items: [
             double(amount: 37, stock_item: double(description: 'stock item 1')),
             double(amount: 73, stock_item: double(description: 'stock item 2'))
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
    it { is_expected.to have_content '60%' }
    it { is_expected.to have_content '3,50 €' }

    it { is_expected.to have_link 'Tabelle anzeigen', href: '#items_per_category_table_collapser' }
    it { is_expected.to have_css '.collapse#items_per_category_table_collapser' }
    it { is_expected.to have_css '#items_per_category_table' }
    it 'lists all categories' do
      event.items_per_category.each do |category_name, item_count|
        is_expected.to have_content category_name
        is_expected.to have_content item_count
      end
    end

    it { is_expected.to have_link 'Tabelle anzeigen', href: '#sold_items_per_category_table_collapser' }
    it { is_expected.to have_css '.collapse#sold_items_per_category_table_collapser' }
    it { is_expected.to have_css '#sold_items_per_category_table' }
    it 'lists all categories of sold items' do
      event.sold_items_per_category.each do |category_name, item_count|
        is_expected.to have_content category_name
        is_expected.to have_content item_count
      end
    end

    it { is_expected.to have_link 'Tabelle anzeigen', href: '#sold_stock_items_table_collapser' }
    it { is_expected.to have_css '.collapse#sold_stock_items_table_collapser' }
    it { is_expected.to have_css '#sold_stock_items_table' }
    it 'lists all sold stock items' do
      event.sold_stock_items.each do |sold_stock_item|
        is_expected.to have_content sold_stock_item.amount
        is_expected.to have_content sold_stock_item.stock_item.description
      end
    end

    it { is_expected.to have_link 'Tabelle anzeigen', href: '#sellers_per_city_table_collapser' }
    it { is_expected.to have_css '.collapse#sellers_per_city_table_collapser' }
    it { is_expected.to have_css '#sellers_per_city_table' }
    it 'lists all seller counts per city' do
      event.sellers_per_city.each do |city, seller_count|
        is_expected.to have_content city
        is_expected.to have_content seller_count
      end
    end

    it { is_expected.to have_content "#{event.reservations.count} / #{event.max_reservations}" }
    it { is_expected.to have_content event.notifications.count }

    it { is_expected.to have_link 'anzeigen', href: '#notifications_collapser' }
    it { is_expected.to have_css '.collapse#notifications_collapser' }

    it 'lists all seller names for the notifications' do
      event.notifications.each { |notification| is_expected.to have_content notification.seller.name }
    end

    it 'lists all seller cities for the notifications' do
      event.notifications.each { |notification| is_expected.to have_content notification.seller.city }
    end
  end
end
