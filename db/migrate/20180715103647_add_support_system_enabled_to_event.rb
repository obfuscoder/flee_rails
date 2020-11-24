class AddSupportSystemEnabledToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :support_system_enabled, :boolean
  end
end
