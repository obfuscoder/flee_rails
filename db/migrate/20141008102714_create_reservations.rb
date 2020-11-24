class CreateReservations < ActiveRecord::Migration[4.2]
  def change
    create_table :reservations do |t|
      t.timestamps null: false

      t.references :seller, index: true
      t.references :event, index: true
      t.integer :number
    end
    add_index :reservations, %i[event_id seller_id], unique: true
    add_index :reservations, %i[event_id number], unique: true
  end
end
