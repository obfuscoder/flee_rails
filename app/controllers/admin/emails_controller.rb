# frozen_string_literal: true

module Admin
  class EmailsController < AdminController
    before_action :set_seller, only: %i[index show]

    def emails
      @email = CustomEmail.new
      set_view_vars
    end

    def create
      @email = CustomEmail.new email_params
      if @email.valid?
        selection = current_client.sellers.merge(Seller.with_mailing).where(id: @email.sellers)
        send_mails(selection)
        redirect_to admin_emails_path, notice: t('.success', count: selection.count)
      else
        set_view_vars
        render :emails
      end
    end

    def index
      @emails = @seller.emails.order(created_at: :desc).page(@page)
    end

    def show
      # TODO: RAILS 5.0 - check if params can still be read
      # see https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#actioncontroller-parameters-no-longer-inherits-from-hashwithindifferentaccess
      @email = @seller.emails.find params[:id]
    end

    private

    def set_seller
      @seller = current_client.sellers.find params[:seller_id]
    end

    def set_view_vars
      @sellers = current_client.sellers.merge(Seller.with_mailing).order(:first_name, :last_name)
      @events = current_client.events
      @json = build_selection_map.to_json
    end

    def build_selection_map
      {
        all: current_client.sellers.merge(Seller.with_mailing).map(&:id),
        active: current_client.sellers.merge(Seller.with_mailing.active).map(&:id),
        inactive: current_client.sellers.merge(Seller.with_mailing).where(active: false).map(&:id),
        events: build_event_map
      }
    end

    def build_event_map
      current_client.events.each_with_object({}) do |event, h|
        h[event.id] = {
          reservation: event.reservations.map(&:seller_id),
          notification: event.notifications.map(&:seller_id),
          items: event.reservations.select { |reservation| reservation.items.any? }.map(&:seller_id)
        }
      end
    end

    def send_mails(selection)
      selection.each do |seller|
        SellerMailer.custom(seller, @email.subject, @email.body).deliver_later
      end
    end

    def email_params
      params.require(:custom_email).permit(:subject, :body, sellers: [])
    end
  end
end
