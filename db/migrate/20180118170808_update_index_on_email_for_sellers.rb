class UpdateIndexOnEmailForSellers < ActiveRecord::Migration[4.2]
  def change
    remove_index :sellers, column: :email
    add_index :sellers, %i[email client_id], unique: true, where: 'deleted_at IS NULL'
  end
end
