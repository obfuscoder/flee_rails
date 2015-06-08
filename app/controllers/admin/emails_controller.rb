module Admin
  class EmailsController < AdminController
    def emails
      @email = Email.new
      @sellers = Seller.where(mailing: true)
      @events = Event.all
    end

    def create
      selection = Seller.where(mailing: true).where(id: params[:email][:sellers])
      subject = params[:email][:subject]
      body = params[:email][:body]
      selection.each do |seller|
        SellerMailer.custom(seller, subject, body).deliver_later
      end
      redirect_to admin_emails_path, notice: t('.success', count: selection.count)
    end
  end
end
