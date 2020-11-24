class AddMaxReservationsPerSellerToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :max_reservations_per_seller, :integer
  end
end
