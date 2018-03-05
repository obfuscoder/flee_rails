# frozen_string_literal: true

class SendInvitationJob < ActiveJob::Base
  queue_as :default

  def perform(seller, event)
    SellerMailer.invitation(seller, event).deliver_now
  end
end
