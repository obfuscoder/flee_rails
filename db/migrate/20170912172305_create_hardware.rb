class CreateHardware < ActiveRecord::Migration
  def change
    create_table :hardware do |t|
      t.timestamps null: false

      t.string :description
      t.decimal :price, precision: 5, scale: 1
    end
    add_index :hardware, :description, unique: true
  end
end
