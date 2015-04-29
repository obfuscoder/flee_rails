class ReservationsController < ApplicationController
  def create
    reservation = Reservation.create event_id: params[:event_id], seller_id: current_seller_id
    if reservation.persisted?
      redirect_to seller_path, notice: t('.success', number: reservation.number)
    else
      redirect_to seller_path, alert: t('.failure')
    end
  end
end
