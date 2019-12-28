class UpdateEmailIndexForUsers < ActiveRecord::Migration
  def change
    remove_index :users, column: :email
    add_index :users, %i[email client_id], unique: true
  end
end
