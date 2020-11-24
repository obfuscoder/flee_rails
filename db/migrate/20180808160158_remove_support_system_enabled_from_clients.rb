class RemoveSupportSystemEnabledFromClients < ActiveRecord::Migration[4.2]
  def change
    remove_column :clients, :support_system_enabled, :boolean
  end
end
