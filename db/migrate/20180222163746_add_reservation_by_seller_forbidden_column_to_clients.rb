class AddReservationBySellerForbiddenColumnToClients < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :reservation_by_seller_forbidden, :boolean
  end
end
