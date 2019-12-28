module Admin
  class SupportersController < AdminController
    before_action :init_event
    before_action :init_support_type
    before_action :init_supporter, only: %i[edit update destroy]
    before_action :init_sellers, only: :new

    def index
      @supporters = @support_type.supporters.joins(:seller).search(params[:search]).page(@page).order(column_order)
    end

    def new
      @supporter = @support_type.supporters.build
    end

    def create
      @supporter = @support_type.supporters.build create_supporter_params
      if @supporter.save
        redirect_to admin_event_support_type_supporters_path(@event, @support_type), notice: t('.success')
      else
        render :new
      end
    end

    def edit; end

    def update
      if @supporter.update update_supporter_params
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

    def create_supporter_params
      params.require(:supporter).permit :seller_id, :comments
    end

    def update_supporter_params
      params.require(:supporter).permit :comments
    end

    def column_order
      'sellers.first_name, sellers.last_name'
    end

    def searchable?
      action_name == 'index'
    end
  end
end
