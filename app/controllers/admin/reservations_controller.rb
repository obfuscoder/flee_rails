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
      reservations = seller_ids.each do |seller_id|
        reservation = @event.reservations.build seller: Seller.find(seller_id)
        reservation.save! context: :admin
      end
      redirect_to admin_event_reservations_path, notice: t('.success', count: reservations.count)
    end

    def destroy
      Reservation.destroy_all event_id: params[:event_id], id: params[:id]
      redirect_to admin_event_reservations_path, notice: t('.success')
    end
  end
end
