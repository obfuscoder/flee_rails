class RemoveTokenIndexFromSellers < ActiveRecord::Migration[4.2]
  def change
    remove_index :sellers, :token
  end
end
