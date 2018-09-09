# frozen_string_literal: true

module Admin
  class SupportersController < AdminController
    before_action :init_event
    before_action :init_support_type
    before_action :init_supporter, only: %i[edit update destroy]
    before_action :init_sellers, only: %i[new edit]

    def index
      @supporters = @support_type.supporters
    end

    def new
      @supporter = @support_type.supporters.build
    end

    def create
      @supporter = @support_type.supporters.build supporter_params
      if @supporter.save
        redirect_to admin_event_support_type_supporters_path(@event, @support_type), notice: t('.success')
      else
        render :new
      end
    end

    def edit; end

    def update
      if @supporter.update supporter_params
        redirect_to admin_event_support_type_supporters_path(@event, @support_type), notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      @supporter.destroy
      redirect_to admin_event_support_type_supporters_path(@event, @support_type), notice: t('.success')
    end

    private

    def init_sellers
      @sellers = @event.client.sellers
                       .merge(Seller.available_for_support_type(@support_type))
                       .order :first_name, :last_name
      @sellers << @supporter.seller if @supporter.present?
    end

    def init_supporter
      @supporter = @support_type.supporters.find params[:id]
    end

    def init_event
      @event = current_client.events.find params[:event_id]
    end

    def init_support_type
      @support_type = @event.support_types.find params[:support_type_id]
    end

    def supporter_params
      params.require(:supporter).permit :seller_id, :comments
    end
  end
end
