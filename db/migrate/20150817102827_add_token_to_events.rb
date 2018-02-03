# frozen_string_literal: true

class AddTokenToEvents < ActiveRecord::Migration
  def change
    add_column :events, :token, :string
    add_index :events, :token, unique: true
  end
end
