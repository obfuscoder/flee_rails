class ChangePrecisionOfSellerFeeInEvents < ActiveRecord::Migration[4.2]
  def up
    change_column :events, :seller_fee, :decimal, precision: 4, scale: 2
  end
end
