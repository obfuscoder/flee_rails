class EventsController < ApplicationController
  before_action :init_event
  before_action :only_with_reservation, :only_after_event_passed, except: :reserve

  def show; end

  def review
    reservation = current_seller.reservations.find_by event: @event
    redirect_to new_event_reservation_review_path(@event, reservation)
  end

  def reserve
    redirect_to event_reservations_create_path(@event)
  end

  private

  def init_event
    @event = current_client.events.find params[:id]
  end
end
