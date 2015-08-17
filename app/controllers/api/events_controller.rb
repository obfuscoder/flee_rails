module Api
  class EventsController < ApplicationController
    before_filter :init_event

    def show
      @categories = Category.all
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
