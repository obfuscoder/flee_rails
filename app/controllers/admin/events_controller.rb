# frozen_string_literal: true

module Admin
  class EventsController < AdminController
    before_action :init_event, only: %i[edit update show stats data bill report]

    def init_event
      @event = current_client.events.find params[:id]
    end

    def index
      @events = current_client.events.page(@page).joining { shopping_periods.outer }.order(column_order).distinct
    end

    def new
      date = 1.month.from_now.at_midday
      @event = current_client.events.build price_precision: current_client.price_precision,
                                           precise_bill_amounts: current_client.precise_bill_amounts,
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
      send_data CreateEventData.new(current_client).call(@event), filename: 'flohmarkthelfer.data'
    end

    def bill
      send_data @event.bill.document, filename: "rechnung_flohmarkthelfer_#{@event.bill.number}.pdf",
                                      type: 'application/pdf'
    end

    def report
      send_data CreateEventReport.new(@event).call, filename: 'artikelliste.txt', type: 'text/plain'
    end

    private

    def create_period(date)
      [min: date, max: date + 2.hours]
    end

    def event_params
      params.require(:event).permit :name, :details, :max_reservations, :kind, :confirmed,
                                    :max_items_per_reservation, :max_reservations_per_seller,
                                    :price_precision, :precise_bill_amounts,
                                    :commission_rate, :reservation_fee,
                                    :reservation_fees_payed_in_advance,
                                    :donation_of_unsold_items_enabled,
                                    :support_system_enabled, :supporters_can_retire,
                                    :reservation_start, :reservation_end,
                                    :handover_start, :handover_end,
                                    :pickup_start, :pickup_end,
                                    shopping_periods_attributes: %i[id min max _destroy],
                                    handover_periods_attributes: %i[id min max _destroy],
                                    pickup_periods_attributes: %i[id min max _destroy]
    end
  end
end
