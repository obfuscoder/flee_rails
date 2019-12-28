module Admin
  class MessagesController < AdminController
    before_action { @event = current_client.events.find params[:event_id] }

    def invitation
      count = SendInvitationMails.new(@event).call
      redirect_to admin_event_path(@event),
                  notice: t('.success', count: count, reservation_count: @event.reservations.size)
    end

    def reservation_closing
      count = SendReservationClosingMails.new(@event).call
      redirect_to admin_event_path(@event), notice: t('.success', count: count)
    end

    def reservation_closed
      count = SendReservationClosedMails.new(@event).call
      redirect_to admin_event_path(@event), notice: t('.success', count: count)
    end

    def finished
      count = SendFinishedMails.new(@event).call
      redirect_to admin_event_path(@event), notice: t('.success', count: count)
    end
  end
end
