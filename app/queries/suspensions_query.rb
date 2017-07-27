# frozen_string_literal: true

class SuspensionsQuery
  def initialize(event)
    @event = event
  end

  def search(needle, page, order_by)
    results.search(needle).includes(:seller).page(page).order(order_by)
  end

  def suspensible_sellers
    Seller.where.not(id: results.map(&:seller_id))
  end

  def create(seller_ids, reason)
    suspensions = seller_ids.map do |seller_id|
      Suspension.create event: @event, seller: Seller.find(seller_id), reason: reason
    end
    suspensions.select(&:valid?)
  end

  def find(id)
    results.find(id)
  end

  private

  def results
    Suspension.where(event: @event)
  end
end
