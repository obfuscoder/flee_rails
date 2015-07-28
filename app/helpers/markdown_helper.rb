module MarkdownHelper
  def markdown(text)
    @markdown ||= Redcarpet::Markdown.new MarkdownWithImageTagRenderer
    @markdown.render text
  end

  class MarkdownWithImageTagRenderer < Redcarpet::Render::HTML
    def image(link, _title, alt_text)
      ActionController::Base.helpers.image_tag link, alt: alt_text
    end
  end
end
