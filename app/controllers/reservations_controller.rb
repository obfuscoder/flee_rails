class ReservationsController < ApplicationController
  def create
    create_reservation params[:event_id]
  end

  def destroy
    destroy_reservations(Reservation.where(event_id: params[:event_id], seller: current_seller))
    redirect_to seller_path, notice: t('.success')
  end
end
