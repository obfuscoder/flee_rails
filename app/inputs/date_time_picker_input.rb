# frozen_string_literal: true

class DateTimePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    template.content_tag(:div, class: 'input-group date form_datetime') do
      template.concat @builder.text_field(attribute_name, merge_wrapper_options(input_html_options, wrapper_options))
      template.concat icon_table
    end
  end

  def icon_table
    content_tag(:span, '', class: %w[input-group-addon glyphicon glyphicon-th])
  end
end
