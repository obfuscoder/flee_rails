class CreateReservedItems < ActiveRecord::Migration
  def change
    create_table :reserved_items do |t|
      t.references :reservation, index: true
      t.references :item, index: true
      t.integer :number
      t.string :code
      t.datetime :sold

      t.timestamps
    end
    add_index :reserved_items, [:reservation_id, :item_id], unique: true
    add_index :reserved_items, [:reservation_id, :number], unique: true
    add_index :reserved_items, :code, unique: true
  end
end
