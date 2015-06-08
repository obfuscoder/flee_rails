class SellerMailer < ActionMailer::Base
  default from: 'info@flohmarkt-koenigsbach.de'

  def registration(seller)
    @seller = seller
    @login_url = login_seller_url(seller.token)
    mail to: seller.email
  end

  def custom(seller, subject, body)
    mail to: seller.email, subject: subject, body: body
  end
end
