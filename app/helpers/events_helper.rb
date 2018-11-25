# frozen_string_literal: true

module EventsHelper
  include TimePeriodsHelper

  def shopping_time(event)
    period event.shopping_periods, exact: event.confirmed?
  end

  def handover_time(event)
    period event.handover_periods, exact: true
  end

  def pickup_time(event)
    period event.pickup_periods, exact: true
  end

  def waiting_list_position(event, seller)
    event.notifications.pluck(:seller_id).index(seller.id) + 1
  end
end
