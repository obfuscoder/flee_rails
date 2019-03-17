# frozen_string_literal: true

class AddDefaultReservationNumberToSeller < ActiveRecord::Migration
  def change
    add_column :sellers, :default_reservation_number, :integer
  end
end
