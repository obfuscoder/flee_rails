class AddItemCounterToReservations < ActiveRecord::Migration[4.2]
  def change
    add_column :reservations, :item_counter, :integer
  end
end
