class RemoveDomainFromClients < ActiveRecord::Migration
  def change
    remove_index :clients, :domain
    remove_column :clients, :domain, :string
  end
end
