# frozen_string_literal: true

class AddFeeAndCommissionRateToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :commission_rate, :decimal
    add_column :reservations, :fee, :decimal
  end
end
