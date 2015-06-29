class SellerMailer < ActionMailer::Base
  default from: Settings.mail.from

  def registration(seller, options)
    @seller = seller
    @login_url = login_seller_url @seller.token, host: options[:host]
    mail to: seller.email
  end

  def notification(notification, options)
    @seller = notification.seller
    @event = notification.event
    @login_url = login_seller_url @seller.token, host: options[:host]
    @reserve_url = login_seller_url @seller.token, goto: :reserve, event: @event, host: options[:host]
    mail to: @seller.email
  end

  def invitation(seller, event, options)
    @seller = seller
    @event = event
    @login_url = login_seller_url @seller.token, host: options[:host]
    @reserve_url = login_seller_url @seller.token, goto: :reserve, event: @event, host: options[:host]
    mail to: seller.email
  end

  def reservation_closing(reservation, options)
    @seller = reservation.seller
    @event = reservation.event
    @login_url = login_seller_url @seller.token, host: options[:host]
    mail to: @seller.email
  end

  def reservation_closed(reservation, labels_pdf, options)
    @seller = reservation.seller
    @event = reservation.event
    @login_url = login_seller_url @seller.token, host: options[:host]
    attachments['etiketten.pdf'] = labels_pdf
    mail to: @seller.email
  end

  def finished(reservation, options)
    @seller = reservation.seller
    @event = reservation.event
    @results_url = login_seller_url @seller.token, goto: :show, event: @event, host: options[:host]
    @review_url = login_seller_url @seller.token, goto: :review, event: @event, host: options[:host]
    mail to: @seller.email
  end

  def custom(seller, subject, body)
    mail to: seller.email, subject: subject, body: body
  end
end
