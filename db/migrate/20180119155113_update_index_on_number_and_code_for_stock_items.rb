class UpdateIndexOnNumberAndCodeForStockItems < ActiveRecord::Migration
  def change
    remove_index :stock_items, column: :number
    remove_index :stock_items, column: :code
    add_index :stock_items, [:number, :client_id], unique: true
    add_index :stock_items, [:code, :client_id], unique: true
  end
end