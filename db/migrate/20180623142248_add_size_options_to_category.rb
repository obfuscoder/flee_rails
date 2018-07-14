# frozen_string_literal: true

class AddSizeOptionsToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :size_option, :integer, default: 0
  end
end
