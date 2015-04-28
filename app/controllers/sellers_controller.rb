class SellersController < ApplicationController
  before_action :set_seller, only: [:show, :edit, :update, :destroy, :allow_mailing, :block_mailing]

  def show
    @events = Event.without_reservation_for @seller
  end

  def new
    @seller = Seller.new
  end

  def edit
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

  def send_registration_mail(seller)
    SellerMailer.registration(seller).deliver
  end

  def update
    if @seller.update(seller_params)
      redirect_to seller_path, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @seller.destroy
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
    reset_session
    seller = Seller.find_by_token params[:token]
    return render "#{Rails.root}/public/401", status: :unauthorized unless seller
    seller.update(active: true)
    session[:seller_id] = seller.id
    redirect_to seller_path
  end

  def block_mailing
    if @seller.update!(mailing: false)
      redirect_to seller_path, notice: t('.success')
    else
      redirect_to seller_path, alert: t('.failure')
    end
  end

  def allow_mailing
    if @seller.update(mailing: true)
      redirect_to seller_path, notice: t('.success')
    else
      redirect_to seller_path, alert: t('.failure')
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seller
    seller_id = session[:seller_id]
    return render "#{Rails.root}/public/401", status: :unauthorized unless seller_id
    @seller = Seller.find session[:seller_id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def seller_params
    params.require(:seller).permit :first_name, :last_name, :street, :zip_code, :city, :email, :phone, :accept_terms
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
