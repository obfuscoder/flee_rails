# frozen_string_literal: true

class AddNameIndexToCategories < ActiveRecord::Migration
  def change
    add_index :categories, :name, where: 'deleted_at IS NULL'
  end
end
