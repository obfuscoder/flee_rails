# frozen_string_literal: true

class SellerMailer < ActionMailer::Base
  helper :events

  include MarkdownHelper

  def registration(seller)
    @seller = seller
    @client = seller.client
    mail_template(__method__)
  end

  def reservation(reservation)
    @reservation = reservation
    @seller = reservation.seller
    @event = reservation.event
    @client = @seller.client
    mail_template(__method__)
  end

  def invitation(seller, event)
    @seller = seller
    @event = event
    @client = seller.client
    mail_template(__method__)
  end

  def reservation_closing(reservation)
    @reservation = reservation
    @seller = reservation.seller
    @event = reservation.event
    @client = @seller.client
    mail_template(__method__)
  end

  def reservation_closed(reservation, labels_pdf)
    @reservation = reservation
    @seller = reservation.seller
    @event = reservation.event
    @client = @seller.client
    attachments['etiketten.pdf'] = labels_pdf
    mail_template(__method__)
  end

  def finished(reservation, receipt_pdf)
    @reservation = reservation
    @seller = reservation.seller
    @event = reservation.event
    @client = @seller.client
    attachments['rechnung.pdf'] = receipt_pdf
    mail_template(__method__)
  end

  def custom(seller, subject, body)
    @seller = seller
    @client = seller.client
    body = body.gsub '{{login_link}}', login_seller_url(seller.token, host: @client.domain)
    mail subject: subject do |format|
      format.text { render plain: body }
      format.html { render html: markdown(body).html_safe }
    end
  end

  private

  def mail_template(category)
    template = fetch_template(category)
    generator = MessageGenerator.new(event: @event, reservation: @reservation, seller: @seller, urls: urls)
    message = generator.generate(template)
    mail to: @seller.email, from: @client.mail_from, subject: message.subject do |format|
      format.text { render plain: message.body }
      format.html { render html: markdown(message.body).html_safe }
    end
  end

  def fetch_template(category)
    @client.message_templates.find_by(category: category) || StockMessageTemplate.find_by!(category: category)
  end

  def mail(headers = {}, &block)
    super(headers.merge(to: @seller.email, from: @client.mail_from), &block)
  end

  def urls
    {
      login: login_seller_url(@seller.token, host: @client.domain),
      results: login_seller_url(@seller.token, host: @client.domain, goto: :show, event: @event),
      review: login_seller_url(@seller.token, host: @client.domain, goto: :review, event: @event),
      reserve: login_seller_url(@seller.token, host: @client.domain, goto: :reserve, event: @event)
    }
  end
end
