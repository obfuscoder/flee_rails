class EventsController < ApplicationController
  before_filter :init_event, :only_with_reservation, :only_after_event_passed

  def show
    @item_count = @event.reservations.joins(:items).count
    @sold_item_count = @event.reservations.joins(:items).merge(Item.sold).count
  end

  def top_sellers
    render json: @event.top_sellers.take(10)
  end

  private

  def init_event
    @event = Event.find params[:id]
  end
end
