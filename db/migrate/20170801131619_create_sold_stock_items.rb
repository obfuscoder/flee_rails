# frozen_string_literal: true

class CreateSoldStockItems < ActiveRecord::Migration
  def change
    create_table :sold_stock_items do |t|
      t.timestamps null: false

      t.references :event, index: true, foreign_key: true
      t.references :stock_item, index: true, foreign_key: true
      t.integer :amount, null: false
    end

    add_index :sold_stock_items, %i[event_id stock_item_id], unique: true
  end
end
