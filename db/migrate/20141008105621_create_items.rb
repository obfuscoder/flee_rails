class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.timestamps

      t.references :category, index: true
      t.string :description
      t.string :size
      t.decimal :price

      t.references :reservation, index: true
      t.integer :number
      t.string :code
      t.datetime :sold
    end
    add_index :items, [:reservation_id, :number], unique: true
    add_index :items, :code, unique: true
  end
end
