# frozen_string_literal: true

class InvitationQuery
  def initialize(event)
    @event = event
  end

  def invitable_sellers
    sellers = @event.client.sellers.merge(Seller.active.with_mailing)
    sellers.reject do |seller|
      @event.suspensions.find_by(seller: seller) ||
        @event.reservations.where(seller: seller).count >= @event.max_reservations_per_seller
    end
  end
end
