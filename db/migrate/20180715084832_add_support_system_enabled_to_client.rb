# frozen_string_literal: true

class AddSupportSystemEnabledToClient < ActiveRecord::Migration
  def change
    add_column :clients, :support_system_enabled, :boolean
  end
end
