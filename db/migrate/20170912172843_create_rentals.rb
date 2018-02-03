# frozen_string_literal: true

class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.timestamps null: false

      t.references :hardware, index: true
      t.references :event, index: true
      t.integer :amount
    end

    add_foreign_key :rentals, :hardware, column: :hardware_id
  end
end
