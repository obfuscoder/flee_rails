class SellerMailer < ActionMailer::Base
  default from: 'info@flohmarkt-koenigsbach.de'

  def registration(seller)
    @seller = seller
    @login_url = login_seller_url(@seller.token)
    mail to: seller.email
  end

  def notification(notification)
    @seller = notification.seller
    @event = notification.event
    @login_url = login_seller_url(@seller.token)
    @reserve_url = reserve_seller_url(@seller.token, @event.id)
    mail to: @seller.email
  end

  def invitation(seller, event)
    @seller = seller
    @event = event
    @login_url = login_seller_url(@seller.token)
    @reserve_url = reserve_seller_url(@seller.token, @event.id)
    mail to: seller.email
  end

  def reservation_closing(reservation)
    @seller = reservation.seller
    @event = reservation.event
    @login_url = login_seller_url(@seller.token)
    mail to: @seller.email
  end

  def reservation_closed(reservation, labels_pdf)
    @seller = reservation.seller
    @event = reservation.event
    @login_url = login_seller_url(@seller.token)
    attachments['etiketten.pdf'] = labels_pdf
    mail to: @seller.email
  end

  def custom(seller, subject, body)
    mail to: seller.email, subject: subject, body: body
  end
end
