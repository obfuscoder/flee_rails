# frozen_string_literal: true

module Admin
  class MessagesController < AdminController
    before_action { @event = current_client.events.find params[:event_id] }

    def invitation
      sellers = current_client.sellers.merge(Seller.active.with_mailing.without_reservation_for(@event))
      sellers.each do |seller|
        SellerMailer.invitation(seller, @event).deliver_later
      end
      @event.messages.create! category: :invitation
      redirect_to admin_event_path(@event),
                  notice: t('.success', count: sellers.count, reservation_count: @event.reservations.size)
    end

    def reservation_closing
      send_mails_and_redirect
    end

    def reservation_closed
      send_mails_and_redirect { |reservation| create_label_document(reservation.items) }
    end

    def finished
      send_mails_and_redirect { |reservation| create_receipt_document(reservation) }
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
          if block_given?
            SellerMailer.send(type, reservation, yield(reservation)).deliver_later
          else
            SellerMailer.send(type, reservation).deliver_later
          end
        rescue StandardError => e
          logger.error e.message
          logger.error e.backtrace.join("\n")
        end
      end
    end

    def create_receipt_document(reservation)
      ReceiptDocument.new(Receipt.new(reservation)).render
    end
  end
end
