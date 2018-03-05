# frozen_string_literal: true

class SendFinishedMails
  def initialize(event)
    @event = event
  end

  def call
    @event.messages.create category: :finished, count: @event.reservations.count
    @event.reservations.each { |reservation| SendFinishedJob.perform_later reservation }
    @event.reservations.count
  end
end
