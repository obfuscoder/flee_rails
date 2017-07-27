class CreateSuspensions < ActiveRecord::Migration
  def change
    create_table :suspensions do |t|
      t.timestamps null: false

      t.references :event, index: true, foreign_key: true
      t.references :seller, index: true, foreign_key: true
      t.string :reason
    end
    add_index :suspensions, [:event_id, :seller_id], unique: true
  end
end
