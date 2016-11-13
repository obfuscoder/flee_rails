class PagesController < ApplicationController
  def home
    return redirect_to :pages_index if brand_key == 'default'
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

  def index
    brands = Settings.brands.to_a
                     .reject { |e| %i(demo default).include? e.first }
                     .sort_by! { |e| e.last.prefix.to_i }
    hosts = Settings.hosts.to_h.invert
    @brands = brands.map do |e|
      OpenStruct.new name: e.last.name,
                     url: "http://#{hosts[e.first.to_s]}"
    end
    render layout: 'index'
  end
end
