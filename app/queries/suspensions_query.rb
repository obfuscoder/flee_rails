class SuspensionsQuery
  def initialize(event)
    @event = event
  end

  def search(needle, page, order_by)
    results.search(needle).includes(:seller).page(page).order(order_by)
  end

  def suspensible_sellers
    @event.client.sellers.where.not(id: results.map(&:seller_id))
  end

  def create(seller_ids, reason)
    suspensions = seller_ids.map do |seller_id|
      @event.suspensions.create seller: @event.client.sellers.find(seller_id), reason: reason
    end
    suspensions.select(&:valid?)
  end

  delegate :find, to: :results

  private

  def results
    @event.suspensions
  end
end
