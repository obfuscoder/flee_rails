class CreateSupportTypes < ActiveRecord::Migration
  def change
    create_table :support_types do |t|
      t.timestamps null: false

      t.string :name
      t.text :description
      t.integer :capacity

      t.references :event, index: true, foreign_key: true
    end
  end
end
