class AddNameIndexToCategories < ActiveRecord::Migration[4.2]
  def change
    add_index :categories, :name, where: 'deleted_at IS NULL'
  end
end
