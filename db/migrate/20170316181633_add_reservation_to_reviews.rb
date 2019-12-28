require 'review'
require 'reservation'

class AddReservationToReviews < ActiveRecord::Migration
  def up
    rename_column :reviews, :reservation, :reservation_process
    add_reference :reviews, :reservation, index: true, foreign_key: true
    Review.all.each do |review|
      reservation = Reservation.find_by event: review.event_id, seller: review.seller_id
      review.update! reservation: reservation
    end
    remove_reference :reviews, :event
    remove_reference :reviews, :seller
  end

  def down
    add_reference :reviews, :event, index: true, foreign_key: true
    add_reference :reviews, :seller, index: true, foreign_key: true
    Review.all.each do |review|
      review.update! event_id: review.reservation.event_id, seller_id: review.reservation.seller_id
    end
    remove_reference :reviews, :reservation
    rename_column :reviews, :reservation_process, :reservation
  end
end
