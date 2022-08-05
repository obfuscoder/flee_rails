class SendFinishedMails
  def initialize(event)
    @event = event
  end

  def call
    @event.messages.create category: :finished, scheduled_count: @event.reservations.count
    @event.reservations.each { |reservation| SendFinishedJob.perform_later reservation }
    AdminMailer.event_finished(@event).deliver_later
    @event.reservations.count
  end
end
