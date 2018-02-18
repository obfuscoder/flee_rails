# frozen_string_literal: true

module Admin
  class EventsController < AdminController
    before_action :init_event, only: %i[edit update show stats data bill]

    def init_event
      @event = current_client.events.find params[:id]
    end

    def index
      @events = current_client.events.page(@page).joins(:shopping_periods).order(column_order).distinct
    end

    def new
      date = 1.month.from_now.at_midday
      @event = current_client.events.build price_precision: current_client.price_precision,
                                           commission_rate: current_client.commission_rate,
                                           reservation_fee: current_client.reservation_fee,
                                           kind: :commissioned,
                                           donation_of_unsold_items_enabled: current_client.donation_of_unsold_items,
                                           reservation_start: date - 2.weeks, reservation_end: date - 2.days,
                                           shopping_periods_attributes: create_period(date),
                                           handover_periods_attributes: create_period(date - 1.day),
                                           pickup_periods_attributes: create_period(date + 1.day)
    end

    def create
      @event = current_client.events.create(event_params)
      if @event.valid?
        redirect_to admin_events_path, notice: t('.success')
      else
        render :new
      end
    end

    def edit; end

    def update
      if @event.update event_params
        auto_reserve(@event)
        redirect_to admin_events_path, notice: t('.success')
      else
        render :edit
      end
    end

    def show; end

    def stats; end

    def data
      response = Jbuilder.new do |json|
        json.call @event, :id, :name, :price_precision, :commission_rate, :reservation_fee,
                  :donation_of_unsold_items_enabled, :reservation_fees_payed_in_advance
        json.categories current_client.categories.all, :id, :name
        json.stock_items current_client.stock_items.all do |stock_item|
          json.description stock_item.description
          json.price stock_item.price
          json.number stock_item.number
          json.code stock_item.code
          json.sold stock_item.sold_stock_items.find_by(event: @event).try(:amount)
        end
        json.sellers @event.reservations.map(&:seller),
                     :id, :first_name, :last_name, :street, :zip_code, :city, :email, :phone
        json.reservations @event.reservations, :id, :number, :seller_id, :fee, :commission_rate
        json.items @event.reservations.map(&:items).flatten.reject { |item| item.code.nil? },
                   :id, :category_id, :reservation_id, :description, :size, :price, :number, :code, :sold, :donation
      end.target!
      send_data ActiveSupport::Gzip.compress(response), filename: 'flohmarkthelfer.data'
    end

    def bill; end

    private

    def create_period(date)
      [min: date, max: date + 2.hours]
    end

    def event_params
      params.require(:event).permit :name, :details, :max_reservations, :kind, :confirmed,
                                    :max_items_per_reservation, :max_reservations_per_seller,
                                    :price_precision, :commission_rate, :reservation_fee,
                                    :reservation_fees_payed_in_advance,
                                    :donation_of_unsold_items_enabled,
                                    :reservation_start, :reservation_end,
                                    :handover_start, :handover_end,
                                    :pickup_start, :pickup_end,
                                    shopping_periods_attributes: %i[id min max _destroy],
                                    handover_periods_attributes: %i[id min max _destroy],
                                    pickup_periods_attributes: %i[id min max _destroy]
    end
  end
end
