class AddNumberColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :number, :integer
    add_index :events, [:number, :client_id], unique: true
  end
end
