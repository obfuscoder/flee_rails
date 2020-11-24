class AddImportItemsAllowedToClients < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :import_items_allowed, :boolean
  end
end
