# frozen_string_literal: true

class SendReservationClosingMails
  def initialize(event)
    @event = event
  end

  def call
    @event.messages.create category: :reservation_closing, scheduled_count: @event.reservations.count
    @event.reservations.each { |reservation| SendReservationClosingJob.perform_later reservation }
    @event.reservations.count
  end
end
