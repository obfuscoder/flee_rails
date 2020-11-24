class AddMaxItemsToReservations < ActiveRecord::Migration[4.2]
  def change
    add_column :reservations, :max_items, :integer
  end
end
