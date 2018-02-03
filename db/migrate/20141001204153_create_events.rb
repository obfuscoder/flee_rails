# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.timestamps null: false

      t.string :name
      t.text :details
      t.integer :max_sellers
      t.integer :max_items_per_seller
      t.boolean :confirmed
    end
  end
end
