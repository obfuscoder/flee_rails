class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.timestamps null: false

      t.references :hardware, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
      t.integer :amount
    end
  end
end
