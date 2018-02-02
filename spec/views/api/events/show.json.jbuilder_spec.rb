# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api/events/show' do
  before do
    event = create :event_with_ongoing_reservation
    reservations = create_list :reservation, 2, event: event
    create_list :item, 3, reservation: reservations.first
    create_list :item, 2, reservation: reservations.second

    stock_items = create_list :stock_item, 4
    event.sold_stock_items.create stock_item: stock_items.first, amount: 2

    assign :stock_items, stock_items
    assign :event, event.reload
    assign :categories, Category.all
    render
  end

  subject(:json) { JSON.parse rendered, symbolize_names: true }

  it { is_expected.to include :id, :name }
  it { is_expected.to include :price_precision, :commission_rate, :reservation_fee, :donation_of_unsold_items_enabled }
  it { is_expected.to include :categories }
  it { is_expected.to include :stock_items }

  describe 'categories' do
    subject(:categories) { json[:categories] }
    it { is_expected.to have(5).items }
    it { is_expected.to all(include(:id, :name)) }
  end

  describe 'stock_items' do
    subject(:stock_items) { json[:stock_items] }
    it { is_expected.to have(4).items }
    it { is_expected.to all(include(:description, :price, :number, :code, :sold)) }
    its(:first) { is_expected.to include sold: 2 }
  end

  describe 'sellers' do
    subject(:sellers) { json[:sellers] }
    it { is_expected.to have(2).items }
    it { is_expected.to all(include(:id, :first_name, :last_name, :street, :zip_code, :city, :phone, :email)) }
  end

  describe 'reservations' do
    subject(:reservations) { json[:reservations] }
    it { is_expected.to have(2).items }
    it { is_expected.to all(include(:id, :number, :seller_id, :fee, :commission_rate)) }
  end

  describe 'items' do
    subject(:items) { json[:items] }
    it { is_expected.to have(5).items }
    it do
      is_expected.to all(include(:id, :category_id, :reservation_id, :description,
                                 :number, :code, :sold, :donation, :size, :price))
    end
  end
end
