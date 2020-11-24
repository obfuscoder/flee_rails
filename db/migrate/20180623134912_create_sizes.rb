class CreateSizes < ActiveRecord::Migration[4.2]
  def change
    create_table :sizes do |t|
      t.timestamps null: false

      t.string :value
      t.references :category, index: true, foreign_key: true
      t.index %i[value category_id], unique: true
    end
  end
end
