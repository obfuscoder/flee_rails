class AddImportItemCodeEnabledToClients < ActiveRecord::Migration
  def change
    add_column :clients, :import_item_code_enabled, :boolean
  end
end
