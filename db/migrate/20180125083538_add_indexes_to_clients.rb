class AddIndexesToClients < ActiveRecord::Migration[4.2]
  def change
    add_index :clients, :key, unique: true
    add_index :clients, :prefix, unique: true
    add_index :clients, :domain, unique: true
  end
end
