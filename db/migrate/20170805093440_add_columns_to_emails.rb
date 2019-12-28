class AddColumnsToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :from, :string
    add_column :emails, :cc, :string
    add_column :emails, :message_id, :string
    add_column :emails, :read, :boolean
    add_column :emails, :kind, :string
    add_reference :emails, :parent, index: true
    add_index :emails, :read
    add_index :emails, :message_id, unique: true
  end
end
