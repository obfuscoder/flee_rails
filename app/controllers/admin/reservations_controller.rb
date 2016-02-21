module Admin
  class ReservationsController < AdminController
    before_action :set_event

    def index
      @reservations = Reservation.search(params[:search])
                                 .where(event_id: params[:event_id])
                                 .includes(:seller, :event)
                                 .page(@page).order(column_order)
    end

    def new
      @sellers = Seller.active.select { |seller| @event.reservable_by? seller }
    end

    def create
      seller_ids = params[:reservation][:seller_id].select { |seller_id| !seller_id.empty? }
      creator = Reservations::CreateReservation.new
      reservations = seller_ids.each do |seller_id|
        creator.create @event, Seller.find(seller_id), { context: :admin },
                       host: request.host, from: brand_settings.mail.from
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

    def searchable?
      action_name == 'index'
    end
  end
end
