class ReservationsController < ApplicationController
  def create
    create_reservation params[:event_id]
  end

  def destroy
    destroy_reservations(Reservation.where(event_id: params[:event_id], seller: current_seller))
    redirect_to seller_path, notice: t('.success')
  end

  private

  def create_reservation(event_id)
    event = Event.find event_id
    reservation = Reservations::CreateReservation.new.create event, current_seller, {},
                                                             host: request.host, from: brand_settings.mail.from
    if reservation.persisted?
      redirect_to seller_path, notice: t('.success', number: reservation.number)
    else
      redirect_to seller_path, alert: t('.failure', reason: reservation.errors.messages.values.join(','))
    end
  end
end
