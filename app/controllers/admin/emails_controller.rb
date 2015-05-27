module Admin
  class EmailsController < AdminController
    def emails
      @email = Email.new
      @sellers = Seller.where(mailing: true)
      @events = Event.all
    end

    def create
      selection = Seller.where(mailing: true)
      selection = case params[:email][:active]
                  when 'true'
                    selection.where(active: true)
                  when 'false'
                    selection.where(active: [false, nil])
                  else
                    selection
                  end
      redirect_to admin_emails_path, notice: t('.success', count: selection.count)
    end
  end
end
