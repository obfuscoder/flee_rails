class AddMaxItemsPerSellerToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :max_items_per_seller, :integer
  end
end
