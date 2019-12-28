module Admin
  class RentalsController < AdminController
    before_action :set_event
    before_action :set_rental, only: %i[edit destroy]

    def index
      @rentals = query.all
    end

    def new
      @hardware = query.rentable_hardware
      @rental = query.new
    end

    def create
      @hardware = query.rentable_hardware
      @rental = query.create create_rental_params
      if @rental.valid?
        redirect_to admin_event_rentals_path, notice: t('.success')
      else
        render :new
      end
    end

    def edit; end

    def update
      @rental = query.update params[:id], update_rental_params
      if @rental.valid?
        redirect_to admin_event_rentals_path, notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      @rental.destroy
      redirect_to admin_event_rentals_path, notice: t('.success')
    end

    private

    def set_event
      @event = current_client.events.find params[:event_id]
    end

    def query
      @query ||= RentalsQuery.new(@event)
    end

    def set_rental
      @rental = query.find params[:id]
    end

    def create_rental_params
      params.require(:rental).permit :hardware_id, :amount
    end

    def update_rental_params
      params.require(:rental).permit :amount
    end
  end
end
