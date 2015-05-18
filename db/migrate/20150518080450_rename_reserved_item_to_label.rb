class RenameReservedItemToLabel < ActiveRecord::Migration
  def change
    rename_table :reserved_items, :labels
  end
end
