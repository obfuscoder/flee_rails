class CreateTransactionStockItems < ActiveRecord::Migration[4.2]
  def change
    create_table :transaction_stock_items do |t|
      t.timestamps null: false

      t.references :transaction, index: true, foreign_key: true, null: false
      t.references :stock_item, index: true, foreign_key: true, null: false
      t.integer :amount
      t.index %i[transaction_id stock_item_id], unique: true,
                                                name: :index_transaction_stock_items_on_transaction_and_stock_item
    end
  end
end
