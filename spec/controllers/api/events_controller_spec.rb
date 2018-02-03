# frozen_string_literal: true

require 'rails_helper'

module Api
  RSpec.describe EventsController do
    describe 'GET show' do
      let!(:event) { create :event }
      let!(:categories) { create_list :category, 5 }
      let!(:stock_items) { create_list :stock_item, 4 }
      before do
        prerequisites
        get :show, format: :json
      end

      context 'with valid access token' do
        let(:prerequisites) do
          @request.env['HTTP_AUTHORIZATION'] =
            ActionController::HttpAuthentication::Token.encode_credentials event.token
        end
        describe 'response' do
          subject { response }
          it { is_expected.to have_http_status :ok }
          its(:content_type) { is_expected.to eq 'application/json' }
        end

        describe '@event' do
          subject { assigns :event }
          it { is_expected.to eq event }
        end

        describe '@categories' do
          subject { assigns :categories }
          it { is_expected.to eq categories }
        end

        describe '@stock_items' do
          subject { assigns :stock_items }
          it { is_expected.to eq stock_items }
        end
      end

      context 'with invalid access token' do
        let(:prerequisites) {}
        describe 'response' do
          subject { response }
          it { is_expected.to have_http_status :unauthorized }
        end
      end
    end

    describe 'POST transactions' do
      let!(:event) { create :event_with_ongoing_reservation }
      let!(:reservation) { create :reservation, event: event }
      let(:category) { create :category }
      let!(:items) { create_list :item_with_code, 10, category: category, reservation: reservation }
      let!(:stock_items) { create_list :stock_item, 5 }
      let(:transactions) do
        [
          {
            id: 'damaged',
            items: items.take(2).map(&:code),
            type: 'UNKNOWN',
            date: '2015-08-27T10:57:29.094+02'
          },
          {
            id: 'b1b3f5ea-0ed7-4f06-85d9-4837a56dc058',
            items: items.take(5).map(&:code),
            type: 'PURCHASE',
            date: '2015-08-27T10:57:29.094+02'
          },
          {
            id: 'f4bddeeb-e8a7-4f44-bf94-b974ebfd60d3',
            items: items.drop(5).take(3).map(&:code),
            type: 'PURCHASE',
            date: '2015-08-27T10:57:29.102+02'
          },
          {
            id: 'd308a289-fc58-4f0d-82ba-95dc8b42eaa6',
            items: items.drop(1).take(2).map(&:code),
            type: 'REFUND',
            date: '2015-08-27T10:57:29.105+02'
          },
          {
            id: 'd308a289-fc58-4f0d-82ba-95dc8b42eaa7',
            items: stock_items.take(2).map(&:code) + stock_items.take(1).map(&:code),
            type: 'PURCHASE',
            date: '2015-08-27T10:57:30.105+02'
          },
          {
            id: 'd308a289-fc58-4f0d-82ba-95dc8b42eaa8',
            items: (stock_items.drop(1).take(2) + items.drop(8).take(2)).map(&:code),
            type: 'PURCHASE',
            date: '2015-08-27T10:57:31.105+02'
          },
          { # this transaction should be ignored as it is repeated
            id: 'd308a289-fc58-4f0d-82ba-95dc8b42eaa8',
            items: (stock_items.drop(1).take(2) + items.drop(8).take(2)).map(&:code),
            type: 'PURCHASE',
            date: '2015-08-27T10:57:31.105+02'
          }
        ]
      end

      before do
        prerequisites
        @request.env['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Token.encode_credentials event.token
        post :transactions, _json: transactions, format: :json
      end

      let(:prerequisites) {}

      describe 'response' do
        subject { response }
        it { is_expected.to have_http_status :ok }
      end

      it 'sets sold date on sold items' do
        items.drop(5).take(5).each { |item| expect(item.reload.sold).not_to be_nil }
        expect(items.first.reload).not_to be_nil
        items.drop(3).take(2).each { |item| expect(item.reload.sold).not_to be_nil }
        items.drop(1).take(2).each { |item| expect(item.reload.sold).to be_nil }
      end

      it 'creates sold_stock_items and adds their sold counts' do
        [2, 2, 1].each_with_index do |sold, index|
          sold_stock_item = stock_items[index].sold_stock_items.find_by(event: event)
          expect(sold_stock_item).not_to be_nil
          expect(sold_stock_item.amount).to eq sold
        end
      end

      it 'stores unique transactions' do
        expect(event.transactions).to have(5).items
      end

      [5, 3, 2, 0, 2].each_with_index do |count, index|
        it "references #{count} items for transaction with index #{index}" do
          expect(event.transactions[index].items.count).to eq count
        end
      end

      [0, 0, 0, 2, 2].each_with_index do |count, index|
        it "references #{count} stock items for transaction with index #{index}" do
          expect(event.transactions[index].stock_items.count).to eq count
        end
      end

      context 'when item category limit has been reduced' do
        let(:prerequisites) { category.update! max_items_per_seller: 5 }

        describe 'response' do
          subject { response }
          it { is_expected.to have_http_status :ok }
        end

        it 'sets sold date on sold items' do
          items.drop(5).take(5).each { |item| expect(item.reload.sold).not_to be_nil }
        end
      end
    end
  end
end
