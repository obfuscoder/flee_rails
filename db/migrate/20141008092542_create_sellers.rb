# frozen_string_literal: true

class CreateSellers < ActiveRecord::Migration
  def change
    create_table :sellers do |t|
      t.timestamps null: false

      t.string :first_name
      t.string :last_name
      t.string :street
      t.string :zip_code
      t.string :city
      t.string :email
      t.string :phone
    end
    add_index :sellers, :email, unique: true
  end
end
