# frozen_string_literal: true

class AddAutoReservationNumbersStartToClients < ActiveRecord::Migration
  def change
    add_column :clients, :auto_reservation_numbers_start, :integer
  end
end
