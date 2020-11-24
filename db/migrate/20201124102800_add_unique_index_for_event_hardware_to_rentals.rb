class AddUniqueIndexForEventHardwareToRentals < ActiveRecord::Migration[5.1]
  def change
    add_index :rentals, %i[event_id hardware_id], unique: true
  end
end
