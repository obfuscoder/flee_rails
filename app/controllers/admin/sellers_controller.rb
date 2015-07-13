module Admin
  class SellersController < AdminController
    def index
      @sellers = Seller.page(@page).order(column_order)
    end

    def new
      @seller = Seller.new
    end

    def create
      @seller = Seller.new seller_params
      if @seller.save
        redirect_to admin_sellers_path, notice: t('.success')
      else
        render :new
      end
    end

    def edit
      @seller = Seller.find params[:id]
    end

    def update
      @seller = Seller.find params[:id]
      if @seller.update seller_params
        redirect_to admin_sellers_path, notice: t('.success')
      else
        render :edit
      end
    end

    def show
      @seller = Seller.find params[:id]
    end

    def destroy
      if Seller.destroy params[:id]
        redirect_to admin_sellers_path, notice: t('.success')
      else
        redirect_to admin_sellers_path, alert: t('.failure')
      end
    end

    private

    def seller_params
      params.require(:seller).permit :first_name, :last_name, :street, :zip_code, :city, :email, :phone
    end

    def column_order
      result = super
      result = { first_name: @dir, last_name: @dir } if result.keys.first == 'name'
      result
    end
  end
end
