class SendReservationClosingJob < ApplicationJob
  queue_as :default

  def perform(reservation)
    SellerMailer.reservation_closing(reservation).deliver_now
    reservation.event.messages.find_by!(category: :reservation_closing).sent
  end
end
