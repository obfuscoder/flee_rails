module TimePeriodsHelper
  def period(periods, options = {})
    return '' if periods.empty?

    if options[:exact] != false
      exact_periods(periods)
    else
      l(periods.first.min, format: :month_year)
    end
  end

  def exact_periods(periods)
    return exact_period periods.first if periods.length == 1

    day_periods = periods.group_by { |period| period.min.to_date }
    strings = day_periods.map do |date, time_periods|
      times = time_periods.map { |period| time_period period }.join ' und '
      "#{l(date, format: :week_date)} #{times} Uhr"
    end
    strings.join ' und '
  end

  def time_period(period)
    "#{time(period.min)} - #{time(period.max)}"
  end

  def time(time)
    l(time, format: :time)
  end

  def exact_period(period)
    if period.min.to_date == period.max.to_date
      "#{l(period.min, format: :date)} #{time_period(period)} Uhr"
    else
      "#{l(period.min)} Uhr bis #{l(period.max)} Uhr"
    end
  end
end
