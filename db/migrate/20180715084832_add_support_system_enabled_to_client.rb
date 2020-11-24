class AddSupportSystemEnabledToClient < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :support_system_enabled, :boolean
  end
end
