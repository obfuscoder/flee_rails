class PagesController < ApplicationController
  def home
    return redirect_to :pages_index if Settings.domain == request.host

    events = current_client.events
    return redirect_to :pages_index if events.nil?

    @events = events.merge(Event.current_or_upcoming).joins(:shopping_periods).order('time_periods.min').distinct
  end

  def contact; end

  def imprint; end

  def privacy; end

  def deleted; end

  def index
    demo_client = Client.find_by key: 'demo'
    @clients = Client.where.not id: demo_client.id
    @events = Event.current_or_upcoming
                   .where.not(client: demo_client)
                   .joins(:shopping_periods)
                   .order('time_periods.min')
                   .distinct
    render layout: 'index'
  end
end
