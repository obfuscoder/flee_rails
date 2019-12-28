class RenameMaxSellersColumnInEvents < ActiveRecord::Migration
  def change
    rename_column :events, :max_sellers, :max_reservations
  end
end
