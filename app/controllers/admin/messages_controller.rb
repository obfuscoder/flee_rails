module Admin
  class MessagesController < AdminController
    def invitation
      event = Event.find params[:event_id]
      sellers = Seller.active.with_mailing.without_reservation_for event
      sellers.each do |seller|
        SellerMailer.invitation(seller, event,
                                login_seller_url(seller.token),
                                reserve_seller_url(seller.token, event)).deliver_later
      end
      event.messages.create! category: :invitation
      redirect_to admin_event_path(params[:event_id]),
                  notice: t('.success', count: sellers.count, reservation_count: event.reservations.size)
    end
  end
end
