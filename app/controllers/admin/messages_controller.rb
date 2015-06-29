module Admin
  class MessagesController < AdminController
    before_filter { @event = Event.find params[:event_id] }

    def invitation
      sellers = Seller.active.with_mailing.without_reservation_for @event
      sellers.each do |seller|
        SellerMailer.invitation(seller, @event, host: request.host, from: brand_settings.mail.from).deliver_later
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
      send_mails_and_redirect
    end

    private

    def send_mails_and_redirect
      action = params[:action]
      @event.reservations.each do |reservation|
        if block_given?
          SellerMailer.send(action, reservation, yield(reservation),
                            host: request.host, from: brand_settings.mail.from).deliver_later
        else
          SellerMailer.send(action, reservation, host: request.host, from: brand_settings.mail.from).deliver_later
        end
      end
      @event.messages.create! category: action
      redirect_to admin_event_path(@event), notice: t('.success', count: @event.reservations.count)
    end
  end
end
