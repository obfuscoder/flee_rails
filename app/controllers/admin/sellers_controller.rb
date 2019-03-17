# frozen_string_literal: true

module Admin
  class SellersController < AdminController
    def index
      @sellers = current_client.sellers.search(params[:search]).page(@page).order(column_order)
    end

    def new
      @seller = current_client.sellers.build
    end

    def create
      @seller = current_client.sellers.build seller_params
      if @seller.save
        redirect_to admin_sellers_path, notice: t('.success')
      else
        render :new
      end
    end

    def edit
      @seller = current_client.sellers.find params[:id]
    end

    def update
      @seller = current_client.sellers.find params[:id]
      if @seller.update seller_params
        redirect_to admin_sellers_path, notice: t('.success')
      else
        render :edit
      end
    end

    def show
      @seller = current_client.sellers.find params[:id]
    end

    def destroy
      if current_client.sellers.find(params[:id]).destroy
        redirect_to admin_sellers_path, notice: t('.success')
      else
        redirect_to admin_sellers_path, alert: t('.failure')
      end
    end

    private

    def seller_params
      params.require(:seller).permit :first_name, :last_name, :street,
                                     :zip_code, :city, :email, :phone,
                                     :default_reservation_number
    end

    def column_order
      result = super
      result = { first_name: @dir, last_name: @dir } if result.keys.first == 'name'
      result
    end

    def searchable?
      action_name == 'index'
    end
  end
end
