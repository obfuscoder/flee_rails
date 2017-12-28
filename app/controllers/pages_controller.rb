# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    return redirect_to :pages_index if Settings.domain == request.host
    @events = Event.current_or_upcoming.joins(:shopping_periods).order('time_periods.min').distinct
  end

  def contact; end

  def imprint; end

  def privacy; end

  def deleted; end

  def index
    @clients = Client.where.not(key: 'demo')
    render layout: 'index'
  end
end
