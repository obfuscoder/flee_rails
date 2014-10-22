class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.timestamps

      t.references :seller, index: true
      t.references :category, index: true
      t.string :description
      t.string :size
      t.decimal :price
    end
  end
end
