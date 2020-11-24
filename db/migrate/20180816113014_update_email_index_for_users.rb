class UpdateEmailIndexForUsers < ActiveRecord::Migration[4.2]
  def change
    remove_index :users, column: :email
    add_index :users, %i[email client_id], unique: true
  end
end
