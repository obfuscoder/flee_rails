class RemoveEmailIndexFromSellers < ActiveRecord::Migration[4.2]
  def change
    remove_index :sellers, :email
  end
end
