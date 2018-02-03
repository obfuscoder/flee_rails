# frozen_string_literal: true

class RemoveIndexOnEventAndSellerFromReservations < ActiveRecord::Migration
  def change
    remove_index :reservations, column: %i[event_id seller_id]
  end
end
