module Admin
  class EventsController < AdminController
    def index
      @events = Event.all
    end

    def new
      @event = Event.new price_precision: brand_settings.price_precision,
                         commission_rate: brand_settings.commission_rate,
                         seller_fee: brand_settings.seller_fee,
                         donation_of_unsold_items_enabled: brand_settings.donation_of_unsold_items_enabled,
                         shopping_start: 1.month.from_now,
                         shopping_end: 1.month.from_now + 2.hours,
                         reservation_start: 2.weeks.from_now,
                         reservation_end: 1.month.from_now - 2.days,
                         handover_start: 1.month.from_now - 1.day,
                         handover_end: 1.month.from_now - 1.day + 2.hours,
                         pickup_start: 1.month.from_now + 4.hours,
                         pickup_end: 1.month.from_now + 6.hours
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
                                    :price_precision, :commission_rate, :seller_fee,
                                    :donation_of_unsold_items_enabled,
                                    :shopping_start, :shopping_end,
                                    :reservation_start, :reservation_end,
                                    :handover_start, :handover_end,
                                    :pickup_start, :pickup_end
    end
  end
end
