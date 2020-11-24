class AddReservationFeesPayedInAdvanceToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :reservation_fees_payed_in_advance, :boolean
  end
end
