module Admin
  class ItemsController < AdminController
    before_filter do
      @seller = Seller.find params[:seller_id]
    end

    def index
      @items = Item.all
    end

    def new
      @item = Item.new
    end

    def create
      @item = Item.new item_params, seller: @seller
      if @item.save
        redirect_to admin_seller_items_path(@seller), notice: t('.success')
      else
        render :new
      end
    end

    def edit
      @item = Item.find params[:id]
    end

    def update
      @item = Item.find params[:id]
      if @item.update(item_params.merge(seller: @seller))
        redirect_to admin_seller_items_path(@seller), notice: t('.success')
      else
        render :edit
      end
    end

    def show
      @item = Item.find params[:id]
    end

    def destroy
      if Item.destroy params[:id]
        redirect_to admin_seller_items_path(@seller), notice: t('.success')
      else
        redirect_to admin_seller_items_path(@seller), alert: t('.failure')
      end
    end

    private

    def item_params
      params.require(:item).permit :description, :category_id, :size, :price
    end
  end
end
