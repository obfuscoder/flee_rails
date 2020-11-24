class RemoveNameIndexFromCategories < ActiveRecord::Migration[4.2]
  def change
    remove_index :categories, :name
  end
end
