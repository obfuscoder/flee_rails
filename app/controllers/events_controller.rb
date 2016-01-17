class EventsController < ApplicationController
  before_filter :init_event, :only_with_reservation, :only_after_event_passed

  def show
  end

  def top_sellers
    render json: @event.top_sellers.take(10)
  end

  def items_per_category
    render json: @event.reservations.joins { items }.joins { items.category }.group { items.category.name }
                   .select { [items.category.name, count(items.id).as(count)] }.order { count(items.id).desc }
                   .map { |e| [e.name, e.count] }
  end

  def sold_items_per_category
    render json: @event.reservations.joins { items }.merge(Item.sold).joins { items.category }
                   .group { items.category.name }
                   .select { [items.category.name, count(items.id).as(count)] }.order { count(items.id).desc }
                   .map { |e| [e.name, e.count] }
  end

  def sellers_per_city
    render json: map_to_cities(@event.reservations
                   .joins { seller }
                   .group { seller.zip_code }
                   .select { [seller.zip_code, count(seller.id).as(count)] })
  end

  private

  def map_to_cities(result)
    result.map { |e| [Rails.application.config.zip_codes[e.zip_code] || e.zip_code, e.count] }
      .each_with_object({}) { |(z, c), h| h[z] = (h[z] || 0) + c }
      .to_a.sort { |a, b| b.second <=> a.second }
  end

  def init_event
    @event = Event.find params[:id]
  end
end
