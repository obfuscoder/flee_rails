class CreateCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :categories do |t|
      t.timestamps null: false

      t.string :name
    end
    add_index :categories, :name, unique: true
  end
end
