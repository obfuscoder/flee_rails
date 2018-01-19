class UpdateIndexOnEmailInUsers < ActiveRecord::Migration
  def change
    remove_index :users, column: :email
    add_index :users, [:email, :client_id], unique: true
  end
end
