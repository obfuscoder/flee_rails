class EventsController < ApplicationController
  before_filter :init_event, :only_with_reservation, :only_after_event_passed

  def show
    @item_count = @event.reservations.joins(:items).count
    @sold_item_count = @event.reservations.joins(:items).merge(Item.sold).count
  end

  def top_sellers
    render json: @event.top_sellers.take(10)
  end

  def items_per_category
    render json: @event.reservations.joins { items }.joins { items.category }.group { [items.category.name] }
                   .select { [items.category.name, count(items.id).as(count)] }.order { count(items.id).desc }
                   .map { |e| [e.name, e.count] }
  end

  def sold_items_per_category
    render json: @event.reservations.joins { items }.merge(Item.sold).joins { items.category }
                   .group { [items.category.name] }
                   .select { [items.category.name, count(items.id).as(count)] }.order { count(items.id).desc }
                   .map { |e| [e.name, e.count] }
  end

  private

  def init_event
    @event = Event.find params[:id]
  end
end
