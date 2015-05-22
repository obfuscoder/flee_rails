module Admin
  class EventsController < AdminController
    def index
      @events = Event.all
    end

    def new
      @event = Event.new
    end

    def create
      @event = Event.new event_params
      if @event.save
        redirect_to admin_events_path, notice: t('.success')
      else
        render :new
      end
    end

    def edit
      @event = Event.find params[:id]
    end

    def update
      @event = Event.find params[:id]
      if @event.update event_params
        redirect_to admin_events_path, notice: t('.success')
      else
        render :edit
      end
    end

    def show
      @event = Event.find params[:id]
    end

    def destroy
      if Event.destroy params[:id]
        redirect_to admin_events_path, notice: t('.success')
      else
        redirect_to admin_events_path, alert: t('.failure')
      end
    end

    private

    def event_params
      params.require(:event).permit :name, :details, :max_sellers, :max_items_per_seller,
                                    :shopping_start, :shopping_end,
                                    :reservation_start, :reservation_end,
                                    :handover_start, :handover_end,
                                    :pickup_start, :pickup_end
    end
  end
end
