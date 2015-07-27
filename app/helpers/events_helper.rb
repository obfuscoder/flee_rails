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
end
