class AddParentIdToCategory < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :parent_id, :integer
    add_foreign_key :categories, :categories, column: :parent_id
  end
end
