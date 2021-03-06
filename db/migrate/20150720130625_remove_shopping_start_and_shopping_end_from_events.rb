class RemoveShoppingStartAndShoppingEndFromEvents < ActiveRecord::Migration[4.2]
  def up
    remove_columns :events, :shopping_start, :shopping_end
  end

  def down
    add_column :events, :shopping_start, :datetime
    add_column :events, :shopping_end, :datetime
  end
end
