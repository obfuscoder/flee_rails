# frozen_string_literal: true

class AddIndexesToClients < ActiveRecord::Migration
  def change
    add_index :clients, :key, unique: true
    add_index :clients, :prefix, unique: true
    add_index :clients, :domain, unique: true
  end
end
