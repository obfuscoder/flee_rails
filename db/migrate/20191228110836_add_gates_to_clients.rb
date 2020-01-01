class AddGatesToClients < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :gates, :boolean
  end
end
