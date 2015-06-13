module Admin
  class EmailsController < AdminController
    def emails
      @email = Email.new
      @sellers = Seller.with_mailing
      @events = Event.all
    end

    def create
      selection = Seller.with_mailing.where(id: params[:email][:sellers])
      subject = params[:email][:subject]
      body = params[:email][:body]
      selection.each do |seller|
        SellerMailer.custom(seller, subject, body).deliver_later
      end
      redirect_to admin_emails_path, notice: t('.success', count: selection.count)
    end
  end
end
