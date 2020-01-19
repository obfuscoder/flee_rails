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

  def gates?
    event.gates ? true : false
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
    @sold_items ||= @reservation.items.sold
  end

  def returned_items
    @returned_items ||= fetch_returned_items
  end

  def donated_items
    @donated_items ||= fetch_donated_items
  end

  def missing_items
    @missing_items ||= @reservation.items.where(checked_in: nil)
  end

  def lost_items
    @lost_items ||= @reservation.items.checked_in.where(sold: nil, donation: [nil, false], checked_out: nil)
  end

  def sold_items_sum
    @sold_items_sum ||= sold_items.map(&:price).inject(:+) || 0
  end

  def reservation_fee
    - @reservation.fee
  end

  private

  def fetch_donated_items
    query = @reservation.items.where(sold: nil, donation: true)
    query = query.checked_in if gates?
    query
  end

  def fetch_returned_items
    query = @reservation.items.where(sold: nil, donation: [nil, false])
    query = query.checked_in.checked_out if gates?
    query
  end

  def round(value)
    if event.precise_bill_amounts
      value.round(2)
    else
      (value / event.price_precision).ceil * reservation.event.price_precision
    end
  end
end
