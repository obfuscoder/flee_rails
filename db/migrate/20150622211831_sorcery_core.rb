# frozen_string_literal: true

class SorceryCore < ActiveRecord::Migration
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
