class AddItemCounterToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :item_counter, :integer
  end
end
