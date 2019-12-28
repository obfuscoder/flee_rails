class RenameSellerFeeColumnInEvents < ActiveRecord::Migration
  def change
    rename_column :events, :seller_fee, :reservation_fee
  end
end
