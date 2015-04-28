class PagesController < ApplicationController
  def home
    @events = Event.all
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
