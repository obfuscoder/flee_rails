class SendInvitationJob < ApplicationJob
  queue_as :default

  def perform(seller, event)
    SellerMailer.invitation(seller, event).deliver_now
    event.messages.find_by!(category: :invitation).sent
  end
end
