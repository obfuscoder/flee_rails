class AddMaxReservationsPerSellerToEvent < ActiveRecord::Migration
  def change
    add_column :events, :max_reservations_per_seller, :integer
  end
end
