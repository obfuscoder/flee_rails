module EventsHelper
  include TimePeriodsHelper

  def shopping_time(event)
    period event.shopping_periods, exact: event.confirmed?
  end
end
