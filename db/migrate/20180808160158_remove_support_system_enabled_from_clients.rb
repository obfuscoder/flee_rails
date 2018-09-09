# frozen_string_literal: true

class RemoveSupportSystemEnabledFromClients < ActiveRecord::Migration
  def change
    remove_column :clients, :support_system_enabled, :boolean
  end
end
