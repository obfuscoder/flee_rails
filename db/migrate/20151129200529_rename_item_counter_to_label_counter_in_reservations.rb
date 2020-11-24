class RenameItemCounterToLabelCounterInReservations < ActiveRecord::Migration[4.2]
  def change
    rename_column :reservations, :item_counter, :label_counter
  end
end
