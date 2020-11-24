class AddSizeOptionsToCategory < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :size_option, :integer, default: 0
  end
end
