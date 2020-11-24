class AddSellerFeeToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :seller_fee, :decimal, precision: 3, scale: 2
  end
end
