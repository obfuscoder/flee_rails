module Api
  class EventsController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :init_event

    def show
      send_data CreateEventData.new(@event.client).call(@event), filename: 'flohmarkthelfer.data'
    end

    def transactions
      ImportTransactions.new(@event).call(transaction_params)
      head :no_content
    end

    private

    def init_event
      authenticate_or_request_with_http_token do |token, _options|
        Rails.logger.info "Token: #{token}"
        @event = Event.find_by token: token
        @event.present?
      end
    end

    def transaction_params
      params.permit(_json: [:id, :type, :date, { items: [] }]).to_h.first.last
    end
  end
end
