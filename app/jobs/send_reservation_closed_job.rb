# frozen_string_literal: true

class SendReservationClosedJob < ApplicationJob
  queue_as :default

  def perform(reservation)
    SellerMailer.reservation_closed(reservation).deliver_now
    reservation.event.messages.find_by!(category: :reservation_closed).sent
  end
end
