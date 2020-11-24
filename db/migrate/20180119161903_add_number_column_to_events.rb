class AddNumberColumnToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :number, :integer
    add_index :events, %i[number client_id], unique: true
  end
end
