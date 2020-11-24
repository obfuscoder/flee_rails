class AddPricePrecisionToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :price_precision, :decimal, precision: 3, scale: 2
  end
end
