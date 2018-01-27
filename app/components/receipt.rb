# frozen_string_literal: true

class Receipt
  def initialize(reservation)
    @reservation = reservation

    commission_cut_sum =
      (sold_items_sum * (1 - reservation.commission_rate) / reservation.event.price_precision).floor *
      reservation.event.price_precision
    @payout = commission_cut_sum
    @payout -= reservation.fee unless event.reservation_fees_payed_in_advance
    @commission_cut = commission_cut_sum - sold_items_sum
  end

  attr_reader :reservation, :commission_cut, :payout

  def donation_enabled?
    event.donation_of_unsold_items_enabled ? true : false
  end

  def seller
    @reservation.seller
  end

  def event
    @reservation.event
  end

  def date
    Time.now.strftime '%d. %m. %Y'
  end

  def sold_items
    @sold_items ||= @reservation.items.where.not(sold: nil)
  end

  def returned_items
    @returned_items ||= @reservation.items.where(sold: nil).where(donation: [nil, false])
  end

  def donated_items
    @donated_items ||= @reservation.items.where(sold: nil).where(donation: true)
  end

  def sold_items_sum
    @sold_items_sum ||= sold_items.map(&:price).inject(:+) || 0
  end

  def reservation_fee
    - @reservation.fee
  end
end
