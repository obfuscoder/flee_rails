class ReservationsController < ApplicationController
  def create
    create_reservation params[:event_id]
  end

  def destroy
    Reservation.destroy_all(event_id: params[:event_id], seller: current_seller)
    redirect_to seller_path, notice: t('.success')
  end
end
