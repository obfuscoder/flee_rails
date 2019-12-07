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

  def bill(event)
    @event = event
    @bill = event.bill
    @client = @event.client
    attachments["flohmarkthelfer_rechnung_#{@bill.number}.pdf"] = event.bill.document
    mail_template(__method__, from: Settings.bill.issuer.email, bcc: Settings.bill.issuer.email)
  end

  def contact(options)
    @client = options[:client]
    @seller = options[:seller]
    @email = options[:email]
    @name = options[:name]
    @body = options[:body]
    @subject = options[:subject]
    mail_template(__method__)
  end

  def label_document_created(event, download_url)
    @event = event
    @client = @event.client
    @urls = { download: download_url }
    mail_template(__method__)
  end

  private

  def mail_template(category, options = {})
    template = fetch_template(category)
    generator = MessageGenerator.new event: @event,
                                     support_type: @support_type,
                                     seller: @seller,
                                     supporter: @supporter,
                                     bill: @bill,
                                     email: @email,
                                     name: @name,
                                     body: @body,
                                     subject: @subject,
                                     urls: @urls
    message = generator.generate(template)
    from = options[:from] || @client.mail_from
    mail_options = { to: @client.mail_from, from: from, subject: message.subject }
    mail_options[:bcc] = options[:bcc] if options[:bcc].present?
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
