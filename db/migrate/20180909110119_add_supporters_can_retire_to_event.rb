class AddSupportersCanRetireToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :supporters_can_retire, :boolean
  end
end
