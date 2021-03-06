module ApplicationHelper
  def flash_class_from_type(type)
    map = { notice: 'success', alert: 'danger', flash: 'warning' }
    "flash bg-#{map[type.to_sym]}"
  end

  def icon_link_to(name = nil, options = nil, html_options = nil, &block)
    opts = get_opts(html_options, options)
    opts[:title] = name if name.present?
    link_to '', options, html_options, &block
  end

  def confirm_icon_link_to(link, name:, message:, type:, icon:, method: :post, &block)
    data = { toggle: 'modal',
             target: '#confirm-modal',
             link: link,
             message: message,
             verb: method }.compact
    icon_link_to(name, '#', type: type, icon: icon, data: data, &block)
  end

  def confirm_link_to(link, name:, message:, type:, icon:, method: :post, &block)
    data = { toggle: 'modal',
             target: '#confirm-modal',
             link: link,
             message: message,
             verb: method }.compact
    link_to(name, '#', type: type, icon: icon, data: data, &block)
  end

  def destroy_icon_link_to(link, name: t('destroy'), message: nil, type: :danger, icon: :trash, &block)
    confirm_icon_link_to(link, name: name, message: message, type: type, icon: icon, method: :delete, &block)
  end

  def destroy_link_to(link, name: t('destroy'), message: nil, type: :danger, icon: :trash, &block)
    confirm_link_to(link, name: name, message: message, type: type, icon: icon, method: :delete, &block)
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
      return "#{tag.span('', class: ['glyphicon', "glyphicon-#{icon}"], aria_hidden: true)} #{name}".html_safe
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

  def current_client
    Client.all.to_a.find { |client| client.host_match?(request.host) } || Settings.default_client
  end

  def paginate(collection, params = {})
    will_paginate collection, params: params
  end

  def sort_link_to(model_class, attribute, text = nil)
    text ||= model_class.human_attribute_name(attribute)
    attribute_name = attribute.to_s
    attribute_name = "#{model_class.table_name}.#{attribute}" if controller_name != model_class.table_name
    link_options = { sort: attribute_name, dir: @sort == attribute_name && @dir == 'asc' ? 'desc' : 'asc' }
    order_to_icon = { 'asc' => 'bottom', 'desc' => 'top' }
    icon = @sort == attribute_name ? order_to_icon[@dir] : nil
    span = icon ? tag(:span, class: ['glyphicon', "glyphicon-triangle-#{icon}"]) : ''
    link_to safe_join([text, span]), link_options
  end
end
