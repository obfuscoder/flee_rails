# frozen_string_literal: true

class SendReservationClosingJob < ActiveJob::Base
  queue_as :default

  def perform(reservation)
    SellerMailer.reservation_closing(reservation).deliver_now
  end
end
