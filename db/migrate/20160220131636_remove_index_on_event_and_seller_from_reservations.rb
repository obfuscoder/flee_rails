class RemoveIndexOnEventAndSellerFromReservations < ActiveRecord::Migration[4.2]
  def change
    remove_index :reservations, column: %i[event_id seller_id]
  end
end
