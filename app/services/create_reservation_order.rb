# frozen_string_literal: true

class CreateReservationOrder
  def initialize; end

  def call(reservation)
    ActiveRecord::Base.transaction do
      if reservation.valid?
        Notification.create event: reservation.event, seller: reservation.seller
        CreateReservation.new.delayed reservation
      end
      reservation
    end
  end

  private

  def destroy_notifications(reservation)
    reservation.event.notifications.where(seller: reservation.seller).destroy_all
  end

  def send_reservation_mail(reservation)
    SellerMailer.reservation(reservation).deliver_later
  end
end
