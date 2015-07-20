class PagesController < ApplicationController
  def home
    @events = Event.current_or_upcoming.includes(:shopping_period).order('time_periods.min')
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
