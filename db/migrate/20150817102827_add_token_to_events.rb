class AddTokenToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :token, :string
    add_index :events, :token, unique: true
  end
end
