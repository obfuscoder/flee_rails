# frozen_string_literal: true

module TranslationHelper
  # overwriting localize and alias to handle nil values
  def localize(*args)
    return '' if args.first.nil?

    I18n.localize(*args)
  end

  alias l localize
end
