class UpdateIndexOnEmailForSellers < ActiveRecord::Migration
  def change
    remove_index :sellers, column: :email
    add_index :sellers, [:email, :client_id], unique: true, where: 'deleted_at IS NULL'
  end
end
