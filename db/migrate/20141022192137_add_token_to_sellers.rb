class AddTokenToSellers < ActiveRecord::Migration[4.2]
  def change
    add_column :sellers, :token, :string
    add_index :sellers, :token, unique: true
  end
end
