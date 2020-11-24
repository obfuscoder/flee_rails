class AddReservationNumbersAssignableToClients < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :reservation_numbers_assignable, :boolean
  end
end
