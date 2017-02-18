class AddMaxItemsToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :max_items, :integer
  end
end
