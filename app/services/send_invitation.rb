# frozen_string_literal: true

class SendInvitation
  def initialize(event)
    @event = event
  end

  def call
    sellers = InvitationQuery.new(@event).invitable_sellers
    sellers.each { |seller| SellerMailer.invitation(seller, @event).deliver_now }
    @event.messages.create category: :invitation, count: sellers.count
    sellers.count
  end
end
