class AddDefaultReservationNumberToSeller < ActiveRecord::Migration[4.2]
  def change
    add_column :sellers, :default_reservation_number, :integer
  end
end
