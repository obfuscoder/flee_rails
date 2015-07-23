module TimePeriodsHelper
  def period(periods, options = {})
    if options[:exact] != false
      exact_periods(periods)
    else
      l(periods.first.min, format: :month_year)
    end
  end

  def exact_periods(periods)
    return exact_period periods.first if periods.length == 1
    "#{exact_period(periods.first)} und #{time_period(periods.second)}"
  end

  def time_period(period)
    "von #{time(period.min)} bis #{time(period.max)}"
  end

  def time(time)
    l(time, format: :time)
  end

  def exact_period(period)
    if period.min.to_date == period.max.to_date
      "#{l(period.min, format: :date)} #{time_period(period)}"
    else
      "#{l(period.min)} bis #{l(period.max)}"
    end
  end
end
