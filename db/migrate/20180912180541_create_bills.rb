class CreateBills < ActiveRecord::Migration[4.2]
  def change
    create_table :bills do |t|
      t.references :event, index: true, foreign_key: true
      t.string :number
      t.binary :document

      t.timestamps null: false
    end

    add_index :bills, :number, unique: true
  end
end
