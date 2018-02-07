# frozen_string_literal: true

class CreateReservation
  def initialize; end

  def create(event, seller, save_options = {})
    ActiveRecord::Base.transaction do
      reservation = Reservation.new event: event, seller: seller
      reservation.save(save_options) && send_reservation_mail(reservation) && destroy_notifications(event, seller)
      reservation
    end
  end

  private

  def destroy_notifications(event, seller)
    event.notifications.where(seller: seller).destroy_all
  end

  def send_reservation_mail(reservation)
    SellerMailer.reservation(reservation).deliver_later
  end
end
