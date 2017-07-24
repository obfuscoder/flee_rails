# frozen_string_literal: true

class EventsController < ApplicationController
  before_filter :init_event
  before_filter :only_with_reservation, :only_after_event_passed, except: :reserve

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
    @event = Event.find params[:id]
  end
end
