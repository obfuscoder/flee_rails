module Admin
  class ItemsController < AdminController
    before_filter do
      @reservation = Reservation.find params[:reservation_id]
    end

    def index
      @items = @reservation.items
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

    def delete_code
      item = Item.find params[:id]
      item.delete_code
      redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
    end

    def delete_all_codes
      @reservation.items.each(&:delete_code)
      redirect_to admin_reservation_items_path(@reservation), notice: t('.success')
    end
  end
end
