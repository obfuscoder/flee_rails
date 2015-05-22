module Admin
  class ReservationsController < AdminController
    def index
      @reservations = Reservation.where event_id: params[:event_id]
    end

    def new
      @event = Event.find params[:event_id]
      @sellers = Seller.active.without_reservation_for @event
    end

    def create
      @event = Event.find params[:event_id]
      seller_ids = params[:reservation][:seller_id].select { |seller_id| !seller_id.empty? }
      reservations = seller_ids.map { |seller_id| Reservation.create seller: Seller.find(seller_id), event: @event }
      redirect_to admin_event_reservations_path, notice: t('.success', count: reservations.count)
    end
  end
end
