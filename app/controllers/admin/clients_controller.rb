# frozen_string_literal: true

module Admin
  class ClientsController < AdminController
    before_action :allow_local_request_for_demo

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
                                     :donation_of_unsold_items, :donation_of_unsold_items_default
    end

    def allow_local_request_for_demo
      head :forbidden if remote_request_on_demo?
    end
  end
end
