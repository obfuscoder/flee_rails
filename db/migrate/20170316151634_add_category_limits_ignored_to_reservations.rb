class AddCategoryLimitsIgnoredToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :category_limits_ignored, :boolean
  end
end