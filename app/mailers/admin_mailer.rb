class AdminMailer < ApplicationMailer
  include MarkdownHelper

  def event_created(event)
    mail_template(__method__, client: event.client, event: event)
  end

  def event_upcoming(event)
    mail_template(__method__, client: event.client, event: event)
  end

  def event_finished(event)
    mail_template(__method__, client: event.client, event: event)
  end

  private

  def mail_template(category, data = {})
    template = fetch_template(category)
    generator = MessageGenerator.new data
    message = generator.generate(template)
    mail_options = { to: Settings.mail.notify, from: Settings.mail.from, subject: message.subject }
    mail mail_options do |format|
      format.text { render plain: message.body }
      format.html { render html: markdown(message.body).html_safe }
    end
  end

  def fetch_template(category)
    mailer_scope = self.class.mailer_name.tr('/', '.')
    body = I18n.t(:body, scope: [mailer_scope, category])
    OpenStruct.new subject: default_i18n_subject, body: body
  end
end
