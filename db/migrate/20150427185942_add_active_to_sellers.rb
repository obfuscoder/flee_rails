class AddActiveToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :active, :boolean
  end
end
