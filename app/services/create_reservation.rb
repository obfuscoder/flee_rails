# frozen_string_literal: true

class CreateReservation
  def initialize; end

  def delayed(reservation, save_options = {})
    delay.delayed_call(reservation.event.id, reservation.seller.id, save_options)
  end

  def delayed_call(event_id, seller_id, save_options = {})
    event = Event.find event_id
    seller = Seller.find seller_id
    reservation = Reservation.new event: event, seller: seller
    call reservation, save_options
  end

  def call(reservation, save_options = {})
    ActiveRecord::Base.transaction do
      notification = reservation.event.notifications.find_by seller: reservation.seller
      if reservation.save(save_options)
        notification&.destroy
        send_reservation_mail reservation
      else
        send_reservation_failed_mail notification if notification
      end
      reservation
    end
  end

  private

  def send_reservation_mail(reservation)
    SellerMailer.reservation(reservation).deliver_later
  end

  def send_reservation_failed_mail(notification)
    SellerMailer.reservation_failed(notification).deliver_later
  end
end
