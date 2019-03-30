# frozen_string_literal: true

module Admin
  class SellersController < AdminController
    def index
      @sellers = current_client.sellers.search(params[:search]).page(@page).order(column_order)
    end

    def new
      @seller = current_client.sellers.build
      init_available_numbers
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
      init_available_numbers
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

    def init_available_numbers
      return if current_client.auto_reservation_numbers_start.blank?

      reserved_numbers = current_client.sellers.where.not(id: @seller.id).pluck(:default_reservation_number)
      @available_numbers = [*1..current_client.auto_reservation_numbers_start - 1] - reserved_numbers
    end

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
