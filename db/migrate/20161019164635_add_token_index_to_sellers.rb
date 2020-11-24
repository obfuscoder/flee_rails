class AddTokenIndexToSellers < ActiveRecord::Migration[4.2]
  def change
    add_index :sellers, :token, unique: true, where: 'deleted_at IS NULL'
  end
end
