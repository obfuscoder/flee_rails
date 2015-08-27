module Api
  class EventsController < ApplicationController
    skip_before_filter :verify_authenticity_token

    before_filter :init_event

    def show
      @categories = Category.all
    end

    def transactions
      params['_json'].each do |transaction|
        time = Time.zone.parse transaction['date']
        transaction['items'].each do |item_id|
          item = Item.find item_id
          item.update! sold: time if transaction['type'] == 'PURCHASE'
          item.update! sold: nil if transaction['type'] == 'REFUND'
        end
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
  end
end
