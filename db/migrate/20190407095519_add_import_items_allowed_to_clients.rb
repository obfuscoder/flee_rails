class AddImportItemsAllowedToClients < ActiveRecord::Migration
  def change
    add_column :clients, :import_items_allowed, :boolean
  end
end
