class ChangeTypeOfCommissionRateAndFeeInReservation < ActiveRecord::Migration[4.2]
  def change
    change_column :reservations, :commission_rate, :decimal, precision: 3, scale: 2
    change_column :reservations, :fee, :decimal, precision: 3, scale: 2
  end
end
