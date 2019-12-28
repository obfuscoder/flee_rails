class RemovePickupStartAndPickupEndFromEvents < ActiveRecord::Migration
  def up
    remove_columns :events, :pickup_start, :pickup_end
  end

  def down
    add_column :events, :pickup_start, :datetime
    add_column :events, :pickup_end, :datetime
  end
end
