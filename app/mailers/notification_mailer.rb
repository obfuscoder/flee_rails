# frozen_string_literal: true

class NotificationMailer < ActionMailer::Base
  helper :events

  include MarkdownHelper

  def supporter_created(supporter)
    @supporter = supporter
    @support_type = supporter.support_type
    @seller = supporter.seller
    @event = @support_type.event
    @client = @event.client
    mail_template(__method__)
  end

  def supporter_destroyed(support_type, seller)
    @support_type = support_type
    @seller = seller
    @event = @support_type.event
    @client = @event.client
    mail_template(__method__)
  end

  private

  def mail_template(category)
    template = fetch_template(category)
    generator = MessageGenerator.new(event: @event, support_type: @support_type, seller: @seller, supporter: @supporter)
    message = generator.generate(template)
    mail to: @client.mail_from, from: @client.mail_from, subject: message.subject do |format|
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
