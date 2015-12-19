class EventsController < ApplicationController
  before_filter :init_event, :only_with_reservation, :only_after_event_passed

  def show
  end

  def top_sellers
    render json: @event.top_sellers
  end

  private

  def init_event
    @event = Event.find params[:id]
  end
end
