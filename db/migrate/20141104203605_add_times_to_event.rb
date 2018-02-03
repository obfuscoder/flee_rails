# frozen_string_literal: true

class AddTimesToEvent < ActiveRecord::Migration
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
