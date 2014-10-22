class SellerMailer < ActionMailer::Base
  default from: "info@flohmarkt-koenigsbach.de"

  def registration(seller, login_url)
    @seller = seller
    @login_url = login_url
    mail to: seller.email
  end
end
