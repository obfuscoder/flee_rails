class ReservationsController < ApplicationController
  def create
    reservation = Reservation.create event_id: params[:event_id], seller: current_seller
    if reservation.persisted?
      redirect_to seller_path, notice: t('.success', number: reservation.number)
    else
      redirect_to seller_path, alert: t('.failure')
    end
  end

  def destroy
    Reservation.destroy_all(event_id: params[:event_id], seller: current_seller)
    redirect_to seller_path, notice: t('.success')
  end
end
