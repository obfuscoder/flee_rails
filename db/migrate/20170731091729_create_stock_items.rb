# frozen_string_literal: true

class CreateStockItems < ActiveRecord::Migration
  def change
    create_table :stock_items do |t|
      t.timestamps null: false

      t.string :description
      t.decimal :price, precision: 5, scale: 2
      t.integer :number
      t.string :code
    end
    add_index :stock_items, :number, unique: true
    add_index :stock_items, :code, unique: true
  end
end
