module ApplicationHelper
  def flash_class_from_type(type)
    map = { notice: 'success', alert: 'danger', flash: 'warning' }
    "flash bg-#{map[type.to_sym]}"
  end

  def link_to(name = nil, options = nil, html_options = nil, &block)
    ops = get_opts(html_options, options)
    handle_type(ops)
    name = enhance_name_with_icon(name, ops)
    super
  end

  def enhance_name_with_icon(name, ops)
    icon = ops.delete :icon
    if icon.is_a? Symbol
      icon = icon.to_s.dasherize
      return "<span class=\"glyphicon glyphicon-#{icon}\" aria-hidden=\"true\"></span> #{name}".html_safe
    end
    name
  end

  def handle_type(ops)
    type = ops.delete :type
    return if type.nil?
    ops[:class] = "btn btn-#{type}"
  end

  def get_opts(html_options, options)
    ops = options if options.is_a? Hash
    ops ||= html_options if html_options.is_a? Hash
    ops ||= {}
    ops
  end

  def options_for_inline_radios
    {
      as: :radio_buttons,
      collection_wrapper_tag: :div,
      item_wrapper_tag: nil,
      item_label_class: 'radio-inline'
    }
  end

  def options_for_inline_radios_with_three_state
    options_for_inline_radios.merge collection: { 'Ja' => true, 'Nein' => false, 'egal' => nil }
  end

  def markdown(text)
    @markdown ||= Redcarpet::Markdown.new Redcarpet::Render::HTML
    @markdown.render text
  end
end
