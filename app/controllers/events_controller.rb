class EventsController < ApplicationController
  before_filter :init_event, :only_with_reservation, :only_after_event_passed

  def show
  end

  private

  def init_event
    @event = Event.find params[:id]
  end
end
