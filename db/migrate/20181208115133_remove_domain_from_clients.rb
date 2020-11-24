class RemoveDomainFromClients < ActiveRecord::Migration[4.2]
  def change
    remove_index :clients, :domain
    remove_column :clients, :domain, :string
  end
end
