class AddPriceFactorToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :price_factor, :decimal, precision: 3, scale: 2
  end
end
