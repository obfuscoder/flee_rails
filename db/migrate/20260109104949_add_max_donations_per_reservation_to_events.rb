class AddMaxDonationsPerReservationToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :max_donations_per_reservation, :integer
  end
end
