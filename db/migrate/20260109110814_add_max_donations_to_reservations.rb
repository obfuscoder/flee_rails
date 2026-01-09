class AddMaxDonationsToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :max_donations, :integer
  end
end
