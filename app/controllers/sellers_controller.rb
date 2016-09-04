class SellersController < ApplicationController
  def show
    @seller = current_seller
    @events = Event.within_reservation_time.select do |event|
      event.reservable_by? @seller
    end
  end

  def new
    @seller = Seller.new
  end

  def edit
    @seller = current_seller
  end

  def create
    @seller = Seller.new seller_params
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
    current_seller.destroy
    reset_session
    redirect_to pages_deleted_path
  end

  def resend_activation
    if request.post?
      resend_activation_for params[:seller][:email]
    else
      @seller = Seller.new
    end
  end

  def login
    init_session_and_seller
    goto = params[:goto]
    event = params[:event]
    return redirect_to seller_path if goto.nil? || event.nil?
    path_method = goto == 'show' ? 'event_path' : "event_#{goto}_path"
    redirect_to send(path_method, event)
  rescue UnauthorizedError
    @seller = Seller.new token: params[:token]
    render :reenter
  end

  def reenter
    @seller = Seller.find_by_email(reenter_params[:email]) || Seller.new(reenter_params)
    @seller.update active: true, mailing: true, token: params[:token]
    login if @seller.save context: :reenter
  end

  def init_session_and_seller
    reset_session
    seller = Seller.find_by_token params[:token]
    raise UnauthorizedError unless seller
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

  def reenter_params
    params.require(:seller).permit :first_name, :last_name, :email
  end

  def activate_seller(seller)
    return if seller.active
    seller.update active: true
    Event.reservation_not_yet_ended.without_reservation_for(seller).with_sent(:invitation).each do |event|
      SellerMailer.invitation(seller, event, host: request.host, from: brand_settings.mail.from).deliver_later
    end
  end

  def send_registration_mail(seller)
    SellerMailer.registration(seller, host: request.host, from: brand_settings.mail.from).deliver_later
  end

  def resend_activation_for(email)
    errors = ValidatesEmailFormatOf.validate_email_format email
    if errors.nil?
      unless send_activation_email_when_found(email)
        errors = [t('email_not_found')]
      end
    end
    return unless errors
    @seller = Seller.new(email: email)
    flash.now[:alert] = errors.join, ' '
  end

  def send_activation_email_when_found(email)
    seller = Seller.find_by_email email
    return unless seller
    send_registration_mail(seller)
    render :activation_resent
  end
end
