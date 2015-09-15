class Receipt
  def initialize(reservation)
    @reservation = reservation

    commission_cut_sum =
      (sold_items_sum * (1 - reservation.event.commission_rate) / reservation.event.price_precision).floor *
        reservation.event.price_precision
    @payout = commission_cut_sum - event.seller_fee
    @commission_cut = commission_cut_sum - sold_items_sum
  end

  attr_reader :reservation, :commission_cut, :payout

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

  def sold_items_sum
    @sold_items_sum ||= sold_items.map(&:price).inject(:+) || 0
  end

  def seller_fee
    - @reservation.event.seller_fee
  end
end
