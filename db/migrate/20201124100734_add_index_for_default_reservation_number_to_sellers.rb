class AddIndexForDefaultReservationNumberToSellers < ActiveRecord::Migration[5.1]
  def change
    add_index :sellers, %i[client_id default_reservation_number], unique: true
  end
end
