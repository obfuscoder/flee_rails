class SorceryCore < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.timestamps null: false

      t.string :email, null: false
      t.string :crypted_password
      t.string :salt
    end

    add_index :users, :email, unique: true
  end
end
