class PagesController < ApplicationController
  def home
    @events = Event.current_or_upcoming.joins(:shopping_periods).order('time_periods.min').distinct
  end

  def contact
  end

  def imprint
  end

  def privacy
  end

  def deleted
  end
end
