# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.timestamps null: false

      t.references :category, index: true
      t.string :description
      t.string :size
      t.decimal :price, precision: 5, scale: 1

      t.references :reservation, index: true
      t.integer :number
      t.string :code
      t.datetime :sold
    end
    add_index :items, %i[reservation_id number], unique: true
    add_index :items, :code, unique: true
  end
end
