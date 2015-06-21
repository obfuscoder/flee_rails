module ReviewsHelper
  SOURCES = {
    newspaper: 'Zeitungsanzeige',
    poster: 'Plakataushang',
    internet: 'Internet',
    friends: 'Bekannte/Familie',
    other: 'Sonstiges',
    nil => 'keine Angabe'
  }
  def source_collection
    SOURCES.invert.compact
  end

  def rating_sections
    %w(registration items print reservation mailing content design support handover payoff sale organization total)
  end

  def options_for_inline_radios
    {
      as: :radio_buttons,
      collection_wrapper_tag: :div,
      item_wrapper_tag: nil,
      item_label_class: 'radio-inline'
    }
  end

  def rating_average(section)
    values = @reviews.map(&section.to_sym).compact
    values.sum.to_f / values.count unless values.empty?
  end

  CLASSES_FOR_RATING = {
    nil => '',
    1 => 'success',
    2 => 'info',
    3 => 'warning',
    4 => 'danger',
    5 => 'danger',
    6 => 'danger'
  }

  def class_for_rating(rating)
    CLASSES_FOR_RATING[rating]
  end

  NAMES_FOR_BOOLS = {
    nil => 'keine Angabe',
    false => 'nein',
    true => 'ja'
  }

  def recommends(reviews)
    data = reviews.map(&:recommend)
    hash = data.inject(Hash.new(0)) do |h, e|
      h[e] += 1
      h
    end
    hash.map { |k, v| { count: v, name: NAMES_FOR_BOOLS[k], percentage: v.to_f / data.size * 100 } }
  end

  def sources(reviews)
    data = reviews.map(&:source)
    hash = data.inject(Hash.new(0)) do |h, e|
      h[e] += 1
      h
    end
    hash.map { |k, v| { count: v, name: SOURCES[k.try(:to_sym)], percentage: v.to_f / data.size * 100 } }
  end
end
