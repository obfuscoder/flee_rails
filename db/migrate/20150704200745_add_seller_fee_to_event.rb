class AddSellerFeeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :seller_fee, :decimal, precision: 3, scale: 2
  end
end
