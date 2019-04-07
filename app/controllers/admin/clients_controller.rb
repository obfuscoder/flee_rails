# frozen_string_literal: true

module Admin
  class ClientsController < AdminController
    before_action :deny_remote_request_for_demo, only: [:update]

    def edit
      @client = current_client
    end

    def update
      @client = current_client
      if @client.update client_params
        redirect_to admin_path, notice: t('.success')
      else
        render :edit
      end
    end

    private

    def client_params
      params.require(:client).permit :name, :short_name,
                                     :address, :invoice_address,
                                     :intro, :outro, :terms,
                                     :price_precision, :reservation_fee, :commission_rate,
                                     :donation_of_unsold_items, :donation_of_unsold_items_default,
                                     :reservation_by_seller_forbidden, :reservation_numbers_assignable,
                                     :auto_reservation_numbers_start, :import_items_allowed
    end

    def deny_remote_request_for_demo
      redirect_to edit_admin_client_path, notice: t('.denied_in_demo') if remote_request_on_demo?
    end
  end
end
