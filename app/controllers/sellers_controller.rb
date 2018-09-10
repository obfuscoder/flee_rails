# frozen_string_literal: true

class SellersController < ApplicationController
  def show
    @seller = current_seller
    @events = current_client.events.merge(Event.within_reservation_time)
    @events_with_support = current_client.events.merge(Event.in_need_of_support)
  end

  def new
    @seller = current_client.sellers.build
  end

  def edit
    @seller = current_seller
  end

  def create
    @seller = current_client.sellers.build seller_params
    @seller.active = false
    @seller.mailing = true

    if @seller.save
      send_registration_mail @seller
      render :create, status: :ok
    else
      render :new
    end
  end

  def update
    @seller = current_seller
    if @seller.update(seller_params)
      redirect_to seller_path, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    current_seller.reservations
    current_seller.destroy
    reset_session
    redirect_to pages_deleted_path
  end

  def resend_activation
    if request.post?
      @seller = current_client.sellers.build resend_activation_params
      resend_activation_for @seller
    else
      @seller = current_client.sellers.build
    end
  end

  def login
    init_session_and_seller
    goto = params[:goto]
    event = params[:event]
    if %w[show review reserve].include?(goto)
      if event.present?
        path_method = goto == 'show' ? 'event_path' : "#{goto}_event_path"
        return redirect_to send(path_method, event)
      end
    end
    redirect_to seller_path
  end

  def init_session_and_seller
    reset_session
    sellers = current_client.sellers
    raise UnauthorizedError if sellers.nil?
    seller = sellers.find_by token: params[:token]
    raise UnauthorizedError if seller.blank?
    activate_seller(seller)
    session[:seller_id] = seller.id
  end

  def block_mailing
    current_seller.update!(mailing: false)
    redirect_to seller_path, notice: t('.success')
  end

  def allow_mailing
    current_seller.update!(mailing: true)
    redirect_to seller_path, notice: t('.success')
  end

  private

  def seller_params
    params.require(:seller).permit :first_name, :last_name, :street, :zip_code, :city, :email, :phone, :accept_terms
  end

  def activate_seller(seller)
    return if seller.active
    seller.update active: true
    current_client.events.merge(
      Event.reservation_not_yet_ended.without_reservation_for(seller).with_sent(:invitation)
    ).each do |event|
      SellerMailer.invitation(seller, event).deliver_later if event.reservable_by?(seller)
    end
  end

  def resend_activation_for(seller)
    return unless seller.valid? :resend_activation
    seller = current_client.sellers.find_by email: seller.email
    send_registration_mail(seller)
    render :activation_resent
  end

  def send_registration_mail(seller)
    SellerMailer.registration(seller).deliver_later
  end

  def resend_activation_params
    params.require(:seller).permit :email
  end
end
