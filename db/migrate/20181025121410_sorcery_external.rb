class SorceryExternal < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.timestamps null: false

      t.references :user, index: true, foreign_key: true
      t.string :provider, :uid, null: false
    end

    add_index :authentications, [:provider, :uid]
  end
end
