# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :init_event

  def create
    reservation = CreateReservation.new.call Reservation.new(event: @event, seller: current_seller)
    if reservation.persisted?
      redirect_to seller_path, notice: t('.success', number: reservation.number)
    else
      redirect_to seller_path, alert: t('.failure', reason: reservation.errors.messages.values.join(','))
    end
  end

  def destroy
    destroy_reservations(@event.reservations.where(id: params[:id], seller: current_seller))
    redirect_to seller_path, notice: t('.success')
  end

  private

  def init_event
    @event = current_client.events.find params[:event_id]
  end
end
