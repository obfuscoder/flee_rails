# frozen_string_literal: true

class AddTokenToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :token, :string
    add_index :sellers, :token, unique: true
  end
end
