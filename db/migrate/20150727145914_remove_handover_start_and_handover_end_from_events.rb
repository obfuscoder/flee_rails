class RemoveHandoverStartAndHandoverEndFromEvents < ActiveRecord::Migration[4.2]
  def up
    remove_columns :events, :handover_start, :handover_end
  end

  def down
    add_column :events, :handover_start, :datetime
    add_column :events, :handover_end, :datetime
  end
end
