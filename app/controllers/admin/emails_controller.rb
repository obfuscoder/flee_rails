module Admin
  class EmailsController < AdminController
    def emails
      @email = Email.new
      set_view_vars
    end

    def create
      @email = Email.new email_params
      if @email.valid?
        selection = Seller.with_mailing.where(id: @email.sellers)
        send_mails(selection)
        redirect_to admin_emails_path, notice: t('.success', count: selection.count)
      else
        set_view_vars
        render :emails
      end
    end

    private

    def set_view_vars
      @sellers = Seller.with_mailing
      @events = Event.all
      @json = build_selection_map.to_json
    end

    def build_selection_map
      {
        all: Seller.with_mailing.map(&:id),
        active: Seller.with_mailing.active.map(&:id),
        inactive: Seller.with_mailing.where(active: false).map(&:id),
        events: build_event_map
      }
    end

    def build_event_map
      Event.all.each_with_object({}) do |event, h|
        h[event.id] = {
          reservation: event.reservations.map(&:seller_id),
          notification: event.notifications.map(&:seller_id),
          items: event.reservations.select { |reservation| reservation.items.any? }.map(&:seller_id)
        }
      end
    end

    def send_mails(selection)
      selection.each do |seller|
        SellerMailer.custom(seller, @email.subject, @email.body, from: brand_settings.mail.from).deliver_later
      end
    end

    def email_params
      params.require(:email).permit(:subject, :body, sellers: [])
    end
  end
end
