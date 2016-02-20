class RemoveIndexOnEventAndSellerFromReservations < ActiveRecord::Migration
  def change
    remove_index :reservations, column: [:event_id, :seller_id]
  end
end
