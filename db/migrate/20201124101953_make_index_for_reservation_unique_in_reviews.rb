class MakeIndexForReservationUniqueInReviews < ActiveRecord::Migration[5.1]
  def change
    remove_index :reviews, :reservation_id
    add_index :reviews, :reservation_id, unique: true
  end
end
