class RenameMaxSellersColumnInEvents < ActiveRecord::Migration[4.2]
  def change
    rename_column :events, :max_sellers, :max_reservations
  end
end
