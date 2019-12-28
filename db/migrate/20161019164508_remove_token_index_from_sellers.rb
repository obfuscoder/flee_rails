class RemoveTokenIndexFromSellers < ActiveRecord::Migration
  def change
    remove_index :sellers, :token
  end
end
