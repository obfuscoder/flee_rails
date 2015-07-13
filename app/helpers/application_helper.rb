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
    @markdown ||= Redcarpet::Markdown.new MarkdownWithImageTagRenderer
    @markdown.render text
  end

  def brand_settings
    Settings.brands[brand_key]
  end

  def brand_key
    Settings.hosts.try(:[], request.host) || 'default'
  end

  def paginate(collection, params = {})
    will_paginate collection, renderer: BootstrapPagination::Rails, params: params
  end

  class MarkdownWithImageTagRenderer < Redcarpet::Render::HTML
    def image(link, _title, alt_text)
      ActionController::Base.helpers.image_tag link, alt: alt_text
    end
  end

  def sort_link_to(model_class, attribute, text = nil)
    text ||= model_class.human_attribute_name(attribute)
    attribute_name = attribute.to_s
    attribute_name = "#{model_class.table_name}.#{attribute}" if controller_name != model_class.table_name
    link_options = { sort: attribute_name, dir: @sort == attribute_name && @dir == 'asc' ? 'desc' : 'asc' }
    order_to_icon = { 'asc' => 'bottom', 'desc' => 'top' }
    icon = @sort == attribute_name ? order_to_icon[@dir] : nil
    span = icon ? (tag 'span', class: "glyphicon glyphicon-triangle-#{icon}") : ''
    link_to text.html_safe + span.html_safe, link_options
  end
end
