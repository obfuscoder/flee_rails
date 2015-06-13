class SellerMailer < ActionMailer::Base
  default from: 'info@flohmarkt-koenigsbach.de'

  def registration(seller, login_url)
    @seller = seller
    @login_url = login_url
    mail to: seller.email
  end

  def notification(seller, event, login_url, reserve_url)
    @seller = seller
    @event = event
    @login_url = login_url
    @reserve_url = reserve_url
    mail to: seller.email
  end

  def invitation(seller, event, login_url, reserve_url)
    @seller = seller
    @event = event
    @login_url = login_url
    @reserve_url = reserve_url
    mail to: seller.email
  end

  def custom(seller, subject, body)
    mail to: seller.email, subject: subject, body: body
  end
end
