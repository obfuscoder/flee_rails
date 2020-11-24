class AddTimesToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :shopping_start, :datetime
    add_column :events, :shopping_end, :datetime
    add_column :events, :reservation_start, :datetime
    add_column :events, :reservation_end, :datetime
    add_column :events, :handover_start, :datetime
    add_column :events, :handover_end, :datetime
    add_column :events, :pickup_start, :datetime
    add_column :events, :pickup_end, :datetime
  end
end
