class AddFeeAndCommissionRateToReservation < ActiveRecord::Migration[4.2]
  def change
    add_column :reservations, :commission_rate, :decimal
    add_column :reservations, :fee, :decimal
  end
end
