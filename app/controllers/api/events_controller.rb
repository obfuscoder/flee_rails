# frozen_string_literal: true

module Api
  class EventsController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :init_event

    def show
      send_data CreateEventData.new(@event.client).call(@event), filename: 'flohmarkthelfer.data'
    end

    def transactions
      ImportTransactions.new(@event).call(params['_json'])
      render nothing: true
    end

    private

    def init_event
      authenticate_or_request_with_http_token do |token, _options|
        Rails.logger.info "Token: #{token}"
        @event = Event.find_by token: token
        @event.present?
      end
    end
  end
end
