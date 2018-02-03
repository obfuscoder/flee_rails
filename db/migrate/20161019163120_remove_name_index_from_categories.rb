# frozen_string_literal: true

class RemoveNameIndexFromCategories < ActiveRecord::Migration
  def change
    remove_index :categories, :name
  end
end
