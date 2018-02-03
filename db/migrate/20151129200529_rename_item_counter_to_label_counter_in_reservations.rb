# frozen_string_literal: true

class RenameItemCounterToLabelCounterInReservations < ActiveRecord::Migration
  def change
    rename_column :reservations, :item_counter, :label_counter
  end
end
