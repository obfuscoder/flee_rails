# frozen_string_literal: true

class SellerMailer < ActionMailer::Base
  helper :events

  include MarkdownHelper

  def registration(seller, options)
    @seller = seller
    @from = options[:from]
    @login_url = login_seller_url @seller.token, host: options[:host]
    mail(__method__)
  end

  def reservation(reservation, options)
    @seller = reservation.seller
    @from = options[:from]
    @event = reservation.event
    @reservation = reservation
    @login_url = login_seller_url @seller.token, host: options[:host]
    mail(__method__)
  end

  def invitation(seller, event, options)
    @seller = seller
    @from = options[:from]
    @event = event
    @login_url = login_seller_url @seller.token, host: options[:host]
    @reserve_url = login_seller_url @seller.token, goto: :reserve, event: @event, host: options[:host]
    mail(__method__)
  end

  def reservation_closing(reservation, options)
    @seller = reservation.seller
    @from = options[:from]
    @event = reservation.event
    @login_url = login_seller_url @seller.token, host: options[:host]
    mail(__method__)
  end

  def reservation_closed(reservation, labels_pdf, options)
    @seller = reservation.seller
    @from = options[:from]
    @event = reservation.event
    @login_url = login_seller_url @seller.token, host: options[:host]
    attachments['etiketten.pdf'] = labels_pdf
    mail(__method__)
  end

  def finished(reservation, receipt_pdf, options)
    @seller = reservation.seller
    @from = options[:from]
    @event = reservation.event
    @results_url = login_seller_url @seller.token, goto: :show, event: @event, host: options[:host]
    @review_url = login_seller_url @seller.token, goto: :review, event: @event, host: options[:host]
    attachments['rechnung.pdf'] = receipt_pdf
    mail(__method__)
  end

  def custom(seller, subject, body, options)
    @seller = seller
    @from = options[:from]
    body = body.gsub '{{login_link}}', login_seller_url(seller.token, host: options[:host])
    mail __method__, subject: subject do |format|
      format.text { render plain: body }
      format.html { render html: markdown(body).html_safe }
    end
  end

  private

  def mail(_kind, headers = {}, &block)
    super(headers.merge(to: @seller.email, from: @from), &block)
  end
end
