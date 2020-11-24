class CreateNotifications < ActiveRecord::Migration[4.2]
  def change
    create_table :notifications do |t|
      t.timestamps null: false

      t.references :event, index: true
      t.references :seller, index: true
    end
    add_index :notifications, %i[event_id seller_id], unique: true
  end
end
