class AddSupportSystemEnabledToEvent < ActiveRecord::Migration
  def change
    add_column :events, :support_system_enabled, :boolean
  end
end
