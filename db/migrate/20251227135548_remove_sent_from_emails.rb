class RemoveSentFromEmails < ActiveRecord::Migration[6.1]
  def change
    remove_column :emails, :sent, :boolean
  end
end
