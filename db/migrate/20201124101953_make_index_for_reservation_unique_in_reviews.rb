class MakeIndexForReservationUniqueInReviews < ActiveRecord::Migration[5.1]
  def change
    # remove_reference :reviews, :reservation, index: true, foreign_key: true
    add_reference :reviews, :reservation, index: { unique: true }, foreign_key: true
  end
end
