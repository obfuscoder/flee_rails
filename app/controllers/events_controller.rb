class EventsController < ApplicationController
  before_filter :init_event, :only_with_reservation, :only_after_event_passed

  def show
  end

  def top_sellers
    render json: @event.top_sellers.take(10)
  end

  def items_per_category
    render json: @event.items_per_category
  end

  def sold_items_per_category
    render json: @event.sold_items_per_category
  end

  def sellers_per_city
    render json: @event.sellers_per_city
  end

  private

  def init_event
    @event = Event.find params[:id]
  end
end
