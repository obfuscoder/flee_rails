class ReservationsController < ApplicationController
  def create
    create_reservation params[:event_id]
  end

  def destroy
    Reservation.destroy_all(event_id: params[:event_id], seller: current_seller)
    notify_sellers params[:event_id]
    redirect_to seller_path, notice: t('.success')
  end

  private

  def notify_sellers(event_id)
    event = Event.find event_id
    Notification.where(event: event).each do |notification|
      SellerMailer.notification(notification.seller, event,
                                login_seller_url(notification.seller.token),
                                reserve_seller_url(notification.seller.token, event_id)).deliver_later
      notification.destroy
    end
  end
end
