# frozen_string_literal: true

class CreateReservation
  def initialize; end

  def create(event, seller, save_options = {})
    reservation = Reservation.new event: event, seller: seller
    reservation.save(save_options) && SellerMailer.reservation(reservation).deliver_later
    reservation
  end
end
