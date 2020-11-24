class RenameSellerFeeColumnInEvents < ActiveRecord::Migration[4.2]
  def change
    rename_column :events, :seller_fee, :reservation_fee
  end
end
