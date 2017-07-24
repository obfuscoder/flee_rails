# frozen_string_literal: true

module MarkdownHelper
  def markdown(text)
    return if text.nil?
    @markdown ||= Redcarpet::Markdown.new MarkdownWithImageTagRenderer
    @markdown.render(text).html_safe
  end

  class MarkdownWithImageTagRenderer < Redcarpet::Render::HTML
    def image(link, _title, alt_text)
      ActionController::Base.helpers.image_tag link, alt: alt_text
    end
  end
end
