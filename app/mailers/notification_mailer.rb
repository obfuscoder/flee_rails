class NotificationMailer < ApplicationMailer
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

  def reset_password_instructions(user)
    @user = user
    @client = @user.client
    @urls = { password_reset: admin_reset_password_edit_url(@user.reset_password_token, host: @client.domain) }
    mail_template(__method__, to: @user.email)
  end

  def user_created(user, password)
    @user = user
    @client = @user.client
    @email = @user.email
    @password = password
    @urls = { admin: admin_login_url(host: @client.domain) }
    mail_template(__method__, to: @user.email)
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
                                     password: @password,
                                     name: @name,
                                     body: @body,
                                     subject: @subject,
                                     urls: @urls
    message = generator.generate(template)
    from = options[:from] || @client.mail_from
    to = options[:to] || @client.mail_from
    mail_options = { to: to, from: from, subject: message.subject }
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
