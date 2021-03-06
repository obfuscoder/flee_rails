class CreateTransactionItems < ActiveRecord::Migration[4.2]
  def change
    create_table :transaction_items do |t|
      t.timestamps null: false
      t.belongs_to :transaction, index: true, foreign_key: true, null: false
      t.belongs_to :item, index: true, foreign_key: true, null: false
      t.index %i[transaction_id item_id], unique: true
    end
  end
end
