class AddActiveToSeller < ActiveRecord::Migration[4.2]
  def change
    add_column :sellers, :active, :boolean
  end
end
