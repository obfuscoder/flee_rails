module Admin
  class ItemsController < AdminController
    before_filter do
      @reservation = Reservation.find params[:reservation_id]
    end

    def index
      @items = Item.all
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
      @item = Item.find params[:id]
    end

    def update
      @item = Item.find params[:id]
      if @item.update item_params.merge(reservation: @reservation)
        redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
      else
        render :edit
      end
    end

    def show
      @item = Item.find params[:id]
    end

    def destroy
      if Item.destroy params[:id]
        redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
      else
        redirect_to admin_reservation_items_path(@reservation), alert: t('.failure')
      end
    end

    private

    def item_params
      params.require(:item).permit :description, :category_id, :size, :price
    end
  end
end
