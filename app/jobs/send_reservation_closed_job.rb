# frozen_string_literal: true

class SendReservationClosedJob < ActiveJob::Base
  queue_as :default

  def perform(reservation)
    SellerMailer.reservation_closed(reservation).deliver_now
  end
end
