# frozen_string_literal: true

class AddMaxItemsPerSellerToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :max_items_per_seller, :integer
  end
end
