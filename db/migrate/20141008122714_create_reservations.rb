class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :seller, index: true
      t.references :event, index: true
      t.integer :number

      t.timestamps
    end
    add_index :reservations, [:event_id, :seller_id], unique: true
    add_index :reservations, [:event_id, :number], unique: true
  end
end
