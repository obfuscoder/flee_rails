class UodateCountColumnsInMessages < ActiveRecord::Migration[4.2]
  def change
    rename_column :messages, :count, :scheduled_count
    add_column :messages, :sent_count, :integer
  end
end
