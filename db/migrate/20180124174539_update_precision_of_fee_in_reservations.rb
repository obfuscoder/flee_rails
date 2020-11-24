class UpdatePrecisionOfFeeInReservations < ActiveRecord::Migration[4.2]
  def change
    change_column :reservations, :fee, :decimal, precision: 4, scale: 2
  end
end
