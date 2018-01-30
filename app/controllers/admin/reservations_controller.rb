# frozen_string_literal: true

module Admin
  class ReservationsController < AdminController
    before_action :set_event
    before_action :set_reservation, only: %i[edit update]

    def index
      @reservations = @event.reservations.search(params[:search])
                            .includes(:seller, :event)
                            .page(@page)
                            .reorder(column_order)
    end

    def new
      @sellers = current_client.sellers.merge(Seller.active).select { |seller| @event.reservable_by? seller }
    end

    def create
      seller_ids = params[:reservation][:seller_id].reject(&:empty?)
      creator = CreateReservation.new
      client = current_client
      reservations = seller_ids.each do |seller_id|
        creator.create @event, client.sellers.find(seller_id), context: :admin
      end
      redirect_to admin_event_reservations_path, notice: t('.success', count: reservations.count)
    end

    def edit; end

    def update
      if @reservation.update(reservation_params)
        redirect_to admin_event_reservations_path, notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      destroy_reservations(@event.reservations.where(id: params[:id]))
      redirect_to admin_event_reservations_path, notice: t('.success')
    end

    private

    def set_event
      @event = current_client.events.find params[:event_id]
    end

    def set_reservation
      @reservation = @event.reservations.find params[:id]
    end

    def column_order
      result = super
      if result.is_a? String
        column, direction = result.split(/ /)
        return "sellers.first_name #{direction}, sellers.last_name #{direction}" if column == 'sellers.name'
      end
      result
    end

    def searchable?
      action_name == 'index'
    end

    def reservation_params
      params.require(:reservation).permit :fee, :commission_rate, :max_items, :category_limits_ignored
    end
  end
end
