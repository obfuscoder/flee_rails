class AddCategoryLimitsIgnoredToReservations < ActiveRecord::Migration[4.2]
  def change
    add_column :reservations, :category_limits_ignored, :boolean
  end
end
