module Admin
  class ItemsController < AdminController
    before_action :init_categories, only: %i[edit new update create]

    before_filter do
      @reservation = Reservation.find params[:reservation_id]
    end

    def index
      @items = @reservation.items
    end

    def show
      @item = Item.find params[:id]
    end

    def new
      @item = Item.new
    end

    def create
      @item = @reservation.items.build item_params

      if @item.save
        redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
      else
        render :new
      end
    end

    def edit
      @item = @reservation.items.find params[:id]
    end

    def update
      @item = @reservation.items.find params[:id]
      if @item.update item_params
        redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      if Item.destroy params[:id]
        redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
      else
        redirect_to admin_reservation_items_path(@reservation), alert: t('.failure')
      end
    end

    def delete_code
      item = Item.find params[:id]
      item.delete_code
      redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
    end

    def delete_all_codes
      @reservation.items.each(&:delete_code)
      redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
    end

    def labels
      @items = @reservation.items
    end

    def create_labels
      selected_items = @reservation.items.where(id: params[:labels][:item])
      pdf = create_label_document(selected_items)
      send_data pdf, filename: 'etiketten.pdf', type: 'application/pdf'
    end

    def item_params
      enforce_donation params.require(:item).permit(:category_id, :description, :size, :price, :donation)
    end

    def enforce_donation(parameters)
      return parameters unless brand_settings.donation_of_unsold_items_enabled && parameters['category_id'].present?
      category = Category.find parameters['category_id']
      parameters['donation'] = '1' if category.donation_enforced
      parameters
    end

    private

    def init_categories
      @categories = Category.selectable.order(:name).map do |category|
        [
          category.name,
          category.id,
          data: { donation_enforced: category.donation_enforced? }
        ]
      end
    end
  end
end
