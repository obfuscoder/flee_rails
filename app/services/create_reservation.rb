# frozen_string_literal: true

class CreateReservation
  def initialize; end

  def call(reservation, save_options = {})
    ActiveRecord::Base.transaction do
      if reservation.save(save_options)
        destroy_notifications reservation
        send_reservation_mail reservation
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
