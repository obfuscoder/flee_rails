# frozen_string_literal: true

class SendReservationClosedMails
  def initialize(event)
    @event = event
  end

  def call
    @event.messages.create category: :reservation_closed, scheduled_count: @event.reservations.count
    @event.reservations.each { |reservation| SendReservationClosedJob.perform_later reservation }
    @event.reservations.count
  end
end
