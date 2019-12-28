class SendInvitationMails
  def initialize(event)
    @event = event
  end

  def call
    sellers = InvitationQuery.new(@event).invitable_sellers
    @event.messages.create category: :invitation, scheduled_count: sellers.count
    sellers.each { |seller| SendInvitationJob.perform_later seller, @event }
    sellers.count
  end
end
