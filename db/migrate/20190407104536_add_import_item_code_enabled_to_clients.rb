class AddImportItemCodeEnabledToClients < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :import_item_code_enabled, :boolean
  end
end
