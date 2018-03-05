# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportTransactionJob do
  subject(:action) { described_class.perform_now event, transaction }
  let(:event) { create :event_with_ongoing_reservation }
  let(:reservation) { create :reservation, event: event }
  let(:category) { create :category }
  let(:items) { create_list :item_with_code, 10, category: category, reservation: reservation }
  let(:stock_items) { create_list :stock_item, 5 }
  let(:preparations) {}
  let(:transaction) do
    {
      'id' => 'b1b3f5ea-0ed7-4f06-85d9-4837a56dc058',
      'items' => items.take(5).map(&:code) + stock_items.take(2).map(&:code) + stock_items.take(1).map(&:code),
      'type' => 'PURCHASE',
      'date' => '2015-08-27T10:57:29.094+02'
    }
  end
  before do
    preparations
    action
  end

  it 'sets sold date on sold items' do
    items.take(5).each { |item| expect(item.reload.sold).not_to be_nil }
    items.drop(5).take(5).each { |item| expect(item.reload.sold).to be_nil }
  end

  it 'creates sold_stock_items and adds their sold counts' do
    sold_stock_item = stock_items.first.sold_stock_items.find_by event: event
    expect(sold_stock_item.amount).to eq 2

    sold_stock_item = stock_items.second.sold_stock_items.find_by event: event
    expect(sold_stock_item.amount).to eq 1
  end

  describe 'stored transaction' do
    subject(:stored_transaction) { event.transactions.first }
    it { is_expected.to be_purchase }
    its(:number) { is_expected.to eq transaction['id'] }
    its('items.count') { is_expected.to eq 5 }
    its('stock_items.count') { is_expected.to eq 2 }
  end

  context 'with refund transaction' do
    let(:items) { create_list :item_with_code, 7, category: category, reservation: reservation, sold: 1.hour.ago }
    let(:sold_stock_item1) { create :sold_stock_item, stock_item: stock_items.first, event: event, amount: 2 }
    let(:sold_stock_item2) { create :sold_stock_item, stock_item: stock_items.second, event: event, amount: 1 }
    let(:preparations) { [sold_stock_item1, sold_stock_item2] }
    let(:transaction) do
      {
        'id' => 'd308a289-fc58-4f0d-82ba-95dc8b42eaa6',
        'items' => items.take(2).map(&:code) + stock_items.take(2).map(&:code),
        'type' => 'REFUND',
        'date' => '2015-08-27T10:57:29.105+02'
      }
    end

    it 'resets sold date on refunded items' do
      items.take(2).each { |item| expect(item.reload.sold).to be_nil }
      items.drop(2).take(5).each { |item| expect(item.reload.sold).not_to be_nil }
    end

    it 'reduces amount of sold stock items and removes them when zero amount was reached' do
      expect(sold_stock_item1.reload.amount).to eq 1
      expect { sold_stock_item2.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    describe 'stored transaction' do
      subject(:stored_transaction) { event.transactions.first }
      it { is_expected.to be_refund }
      its(:number) { is_expected.to eq transaction['id'] }
      its('items.count') { is_expected.to eq 2 }
      its('transaction_stock_items.count') { is_expected.to eq 2 }
      its('stock_items.count') { is_expected.to eq 2 }
    end
  end
end
