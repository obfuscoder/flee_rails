class AddReservationFeeBasedOnItemCountToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :reservation_fee_based_on_item_count, :boolean
  end
end
