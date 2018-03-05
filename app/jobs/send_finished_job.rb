# frozen_string_literal: true

class SendFinishedJob < ActiveJob::Base
  queue_as :default

  def perform(reservation)
    SellerMailer.finished(reservation).deliver_now
  end
end
