# frozen_string_literal: true

module Api
  class EventsController < ApplicationController
    skip_before_filter :verify_authenticity_token

    before_filter :init_event

    def show
      @categories = Category.all
      @stock_items = StockItem.all
    end

    def transactions
      params['_json'].each do |transaction|
        time = Time.zone.parse transaction['date']
        transaction['items'].each { |code| fetch_and_update_item(code, time, transaction['type']) }
      end
      render nothing: true
    end

    private

    def init_event
      authenticate_or_request_with_http_token do |token, _options|
        @event = Event.find_by_token(token)
        @event.present?
      end
    end

    def fetch_and_update_item(code, time, type)
      item = Item.find_by code: code
      if item.present?
        update_item(item, time, type)
      else
        stock_item = StockItem.find_by code: code
        update_stock_item(stock_item, time, type) if stock_item.present?
      end
    end

    def update_stock_item(stock_item, time, type)
      sold_stock_item = stock_item.sold_stock_items.find_by event: @event
      sold_stock_item = stock_item.sold_stock_items.build(event: @event, created_at: time) if sold_stock_item.nil?
      sold_stock_item.amount += 1 if type == 'PURCHASE'
      sold_stock_item.amount -= 1 if type == 'REFUND' && sold_stock_item.sold.positive?
      sold_stock_item.save! context: :transaction
    end

    def update_item(item, time, type)
      item.sold = time if type == 'PURCHASE'
      item.sold = nil if type == 'REFUND'
      item.save! context: :transaction
    end
  end
end
