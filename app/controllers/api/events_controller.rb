# frozen_string_literal: true

module Api
  class EventsController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :init_event

    def show
      @categories = current_client.categories.all
      @stock_items = current_client.stock_items.all
    end

    def transactions
      ImportTransactions.new(@event).call(params['_json'])
      render nothing: true
    end

    private

    def init_event
      authenticate_or_request_with_http_token do |token, _options|
        @event = current_client.events.find_by token: token
        @event.present?
      end
    end
  end
end
