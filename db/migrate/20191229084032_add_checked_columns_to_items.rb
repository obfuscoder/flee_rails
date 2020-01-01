class AddCheckedColumnsToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :checked_in, :datetime
    add_column :items, :checked_out, :datetime
  end
end
