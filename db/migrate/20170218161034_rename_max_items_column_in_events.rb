class RenameMaxItemsColumnInEvents < ActiveRecord::Migration
  def change
    rename_column :events, :max_items_per_seller, :max_items_per_reservation
  end
end
