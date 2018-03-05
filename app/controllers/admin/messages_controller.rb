# frozen_string_literal: true

module Admin
  class MessagesController < AdminController
    before_action { @event = current_client.events.find params[:event_id] }

    def invitation
      count = SendInvitations.new(@event).call
      redirect_to admin_event_path(@event),
                  notice: t('.success', count: count, reservation_count: @event.reservations.size)
    end

    def reservation_closing
      send_mails_and_redirect
    end

    def reservation_closed
      send_mails_and_redirect
    end

    def finished
      send_mails_and_redirect
    end

    private

    def send_mails_and_redirect(&block)
      action = params[:action]
      send_mails_to_reservations(action, @event.reservations, &block)
      @event.messages.create! category: action
      redirect_to admin_event_path(@event), notice: t('.success', count: @event.reservations.count)
    end

    def send_mails_to_reservations(type, reservations)
      reservations.each do |reservation|
        begin
          SellerMailer.send(type, reservation).deliver_now
        rescue StandardError => e
          logger.error e.message
          logger.error e.backtrace.join("\n")
        end
      end
    end
  end
end
