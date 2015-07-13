module Admin
  class ReservationsController < AdminController
    before_action :set_event

    def index
      @reservations = Reservation.where(event_id: params[:event_id])
                                 .joins(:seller).includes(:seller, :event)
                                 .page(@page).order(column_order)
    end

    def new
      @sellers = Seller.active.without_reservation_for @event
    end

    def create
      seller_ids = params[:reservation][:seller_id].select { |seller_id| !seller_id.empty? }
      reservations = seller_ids.each do |seller_id|
        reservation = @event.reservations.build seller: Seller.find(seller_id)
        reservation.save! context: :admin
      end
      redirect_to admin_event_reservations_path, notice: t('.success', count: reservations.count)
    end

    def destroy
      destroy_reservations(Reservation.where(event_id: params[:event_id], id: params[:id]))
      redirect_to admin_event_reservations_path, notice: t('.success')
    end

    private

    def set_event
      @event = Event.find params[:event_id]
    end

    def column_order
      result = super
      if result.is_a? String
        column, direction = result.split(/ /)
        if column == 'sellers.name'
          return "sellers.first_name #{direction}, sellers.last_name #{direction}"
        end
      end
      result
    end
  end
end
