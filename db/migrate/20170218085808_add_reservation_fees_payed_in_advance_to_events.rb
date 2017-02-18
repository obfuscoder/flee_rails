class AddReservationFeesPayedInAdvanceToEvents < ActiveRecord::Migration
  def change
    add_column :events, :reservation_fees_payed_in_advance, :boolean
  end
end
