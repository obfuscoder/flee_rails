class AddLockedColumnToClients < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      change_table :clients do |t|
        dir.up do
          t.change :key, :string, limit: 40
          t.change :prefix, :string, limit: 4
          t.change :name, :string, limit: 80
          t.change :short_name, :string, limit: 60
          t.change :logo, :string, limit: 40
          t.change :mail_address, :string, limit: 128
        end
        dir.down do
          t.change :key, :string, limit: 255
          t.change :prefix, :string, limit: 255
          t.change :name, :string, limit: 255
          t.change :short_name, :string, limit: 255
          t.change :logo, :string, limit: 255
          t.change :mail_address, :string, limit: 255
        end
      end
    end

    add_column :clients, :locked, :string
  end
end
