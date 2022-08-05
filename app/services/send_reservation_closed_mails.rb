class SendReservationClosedMails
  def initialize(event)
    @event = event
  end

  def call
    @event.messages.create category: :reservation_closed, scheduled_count: @event.reservations.count
    @event.reservations.each { |reservation| SendReservationClosedJob.perform_later reservation }
    AdminMailer.event_upcoming(@event).deliver_later
    @event.reservations.count
  end
end
