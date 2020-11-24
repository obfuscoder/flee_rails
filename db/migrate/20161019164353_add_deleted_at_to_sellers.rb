class AddDeletedAtToSellers < ActiveRecord::Migration[4.2]
  def change
    add_column :sellers, :deleted_at, :datetime
    add_index :sellers, :deleted_at
  end
end
