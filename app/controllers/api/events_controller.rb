module Api
  class EventsController < ApplicationController
    before_filter :init_event

    def show
      @categories = Category.all
    end

    def init_event
      @event = Event.find params[:id]
    end
  end
end
