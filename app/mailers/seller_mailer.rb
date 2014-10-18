class SellerMailer < ActionMailer::Base
  default from: "info@flohmarkt-koenigsbach.de"

  def registration(seller)
    @seller = seller
    mail to: seller.email
  end
end
