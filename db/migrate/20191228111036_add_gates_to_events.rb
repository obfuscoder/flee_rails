class AddGatesToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :gates, :boolean
  end
end
