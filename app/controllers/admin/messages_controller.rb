module Admin
  class MessagesController < AdminController
    def invitation
      event = Event.find params[:event_id]
      sellers = Seller.active.with_mailing.without_reservation_for event
      sellers.each do |seller|
        SellerMailer.invitation(seller, event).deliver_later
      end
      event.messages.create! category: :invitation
      redirect_to admin_event_path(params[:event_id]),
                  notice: t('.success', count: sellers.count, reservation_count: event.reservations.size)
    end

    def reservation_closing
      event = Event.find params[:event_id]
      event.reservations.each do |reservation|
        SellerMailer.reservation_closing(reservation.seller, event).deliver_later
      end
      event.messages.create! category: :reservation_closing
      redirect_to admin_event_path(params[:event_id]), notice: t('.success', count: event.reservations.count)
    end

    def reservation_closed
      event = Event.find params[:event_id]
      event.reservations.each do |reservation|
        SellerMailer.reservation_closed(reservation.seller, event).deliver_later
      end
      event.messages.create! category: :reservation_closed
      redirect_to admin_event_path(params[:event_id]), notice: t('.success', count: event.reservations.count)
    end
  end
end
