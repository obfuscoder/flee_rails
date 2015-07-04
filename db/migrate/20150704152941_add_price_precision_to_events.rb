class AddPricePrecisionToEvents < ActiveRecord::Migration
  def change
    add_column :events, :price_precision, :decimal, precision: 3, scale: 2
  end
end
