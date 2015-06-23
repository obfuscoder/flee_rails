class PagesController < ApplicationController
  def home
    @events = Event.current_or_upcoming.order(:shopping_start)
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
