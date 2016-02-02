module Admin
  class EventsController < AdminController
    before_filter :init_event, only: [:edit, :update, :show, :stats, :items_per_category, :data]

    def init_event
      @event = Event.find params[:id]
    end

    def index
      @events = Event.page(@page).joins(:shopping_periods).order(column_order).distinct
    end

    def new
      date = 1.month.from_now.at_midday
      @event = Event.new price_precision: brand_settings.price_precision,
                         commission_rate: brand_settings.commission_rate,
                         seller_fee: brand_settings.seller_fee,
                         kind: :commissioned,
                         donation_of_unsold_items_enabled: brand_settings.donation_of_unsold_items_enabled,
                         reservation_start: date - 2.weeks, reservation_end: date - 2.days,
                         shopping_periods_attributes: [min: date, max: date + 2.hours],
                         handover_periods_attributes: [min: date - 1.day, max: date - 1.day + 2.hours],
                         pickup_periods_attributes: [min: date + 4.hours, max: date + 6.hours]
    end

    def create
      @event = Event.create(event_params)
      if @event
        redirect_to admin_events_path, notice: t('.success')
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @event.update event_params
        redirect_to admin_events_path, notice: t('.success')
      else
        render :edit
      end
    end

    def show
    end

    def stats
    end

    def data
      response = Jbuilder.new do |json|
        json.call @event, :id, :name, :price_precision, :commission_rate, :seller_fee, :donation_of_unsold_items_enabled
        json.categories Category.all, :id, :name
        json.sellers @event.reservations.map(&:seller),
                     :id, :first_name, :last_name, :street, :zip_code, :city, :email, :phone
        json.reservations @event.reservations, :id, :number, :seller_id
        json.items @event.reservations.map(&:items).flatten, :id, :category_id, :reservation_id,
                   :description, :size, :price, :number, :code, :sold, :donation
      end.target!
      send_data ActiveSupport::Gzip.compress(response), filename: 'flohmarkthelfer.data'
    end

    def items_per_category
      render json: @event.items_per_category
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
      params.require(:event).permit :name, :details, :max_sellers, :kind, :max_items_per_seller, :confirmed,
                                    :price_precision, :commission_rate, :seller_fee,
                                    :donation_of_unsold_items_enabled,
                                    :reservation_start, :reservation_end,
                                    :handover_start, :handover_end,
                                    :pickup_start, :pickup_end,
                                    shopping_periods_attributes: [:id, :min, :max, :_destroy],
                                    handover_periods_attributes: [:id, :min, :max, :_destroy],
                                    pickup_periods_attributes: [:id, :min, :max, :_destroy]
    end
  end
end
