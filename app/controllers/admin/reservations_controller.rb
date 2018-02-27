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
      @reservation = @event.reservations.build
      init_sellers
      init_available_numbers
      render :new
    end

    def new_bulk
      @reservation = @event.reservations.build
      init_sellers
    end

    def create
      creator = CreateReservation.new
      reservation = @event.reservations.build create_reservation_params
      @reservation = creator.call reservation, context: :admin
      if @reservation.persisted?
        redirect_to admin_event_reservations_path, notice: t('.success', count: 1)
      else
        init_sellers
        init_available_numbers
        render :new
      end
    end

    def create_bulk
      creator = CreateReservation.new
      client = current_client
      seller_ids = params[:reservation][:seller_id].reject(&:empty?)
      reservations = seller_ids.map do |seller_id|
        reservation = Reservation.new event: @event, seller: client.sellers.find(seller_id)
        creator.call reservation, context: :admin
      end
      redirect_to admin_event_reservations_path, notice: t('.success', count: reservations.count(&:persisted?))
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

    def create_reservation_params
      params.require(:reservation).permit :fee, :commission_rate, :max_items,
                                          :category_limits_ignored, :number, :seller_id
    end

    def init_sellers
      @sellers = current_client.sellers.merge(Seller.active).select do |seller|
        @event.reservable_by? seller, context: :admin
      end
    end

    def init_available_numbers
      @available_numbers = [*1..500] - @event.reservations.pluck(:number)
    end

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
