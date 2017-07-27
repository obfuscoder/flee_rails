# frozen_string_literal: true

module Admin
  class SuspensionsController < AdminController
    before_action :set_event
    before_action :set_suspension, only: %i[edit update destroy]

    def index
      @suspensions = query.search(params[:search], @page, column_order)
    end

    def new
      @sellers = query.suspensible_sellers
    end

    def create
      reason = params[:suspension][:reason]
      seller_ids = params[:suspension][:seller_id].reject(&:empty?)
      suspensions = query.create(seller_ids, reason)
      redirect_to admin_event_suspensions_path, notice: t('.success', count: suspensions.count)
    end

    def edit; end

    def update
      if @suspension.update(suspension_params)
        redirect_to admin_event_suspensions_path, notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      @suspension.destroy
      redirect_to admin_event_suspensions_path, notice: t('.success')
    end

    private

    def set_event
      @event = Event.find params[:event_id]
    end

    def query
      SuspensionsQuery.new(@event)
    end

    def set_suspension
      @suspension = query.find(params[:id])
    end

    def searchable?
      action_name == 'index'
    end

    def suspension_params
      params.require(:suspension).permit :reason
    end
  end
end
