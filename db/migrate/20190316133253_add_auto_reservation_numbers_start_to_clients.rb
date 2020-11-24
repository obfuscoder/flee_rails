class AddAutoReservationNumbersStartToClients < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :auto_reservation_numbers_start, :integer
  end
end
