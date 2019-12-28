class AddReservationNumbersAssignableToClients < ActiveRecord::Migration
  def change
    add_column :clients, :reservation_numbers_assignable, :boolean
  end
end
