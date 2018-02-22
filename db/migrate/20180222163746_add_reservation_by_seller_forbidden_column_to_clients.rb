# frozen_string_literal: true

class AddReservationBySellerForbiddenColumnToClients < ActiveRecord::Migration
  def change
    add_column :clients, :reservation_by_seller_forbidden, :boolean
  end
end
