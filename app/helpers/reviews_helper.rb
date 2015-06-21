module ReviewsHelper
  def source_collection
    {
      newspaper: 'Zeitungsanzeige',
      poster: 'Plakataushang',
      internet: 'Internet',
      friends: 'Bekannte/Familie',
      other: 'Sonstiges'
    }.invert
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
end
