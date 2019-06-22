# frozen_string_literal: true

class Receipt
  def initialize(reservation)
    @reservation = reservation
    @commission_cut = -round(sold_items_sum * reservation.commission_rate)
    @payout = sold_items_sum + @commission_cut
    @payout -= reservation.fee unless event.reservation_fees_payed_in_advance
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

  private

  def round(value)
    if event.precise_bill_amounts
      value.round(2)
    else
      (value / event.price_precision).ceil * reservation.event.price_precision
    end
  end
end
