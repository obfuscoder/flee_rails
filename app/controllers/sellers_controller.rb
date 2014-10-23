class SellersController < ApplicationController
  before_action :set_seller, only: [:show, :edit, :update, :destroy]

  def index
    @sellers = Seller.all
  end

  def show
  end

  def new
    @seller = Seller.new
  end

  def edit
  end

  def create
    @seller = Seller.new(seller_params)

    respond_to do |format|
      if @seller.save
        SellerMailer.registration(@seller, login_seller_url(@seller.token)).deliver
        format.html { render :create, status: :ok }
        format.json { render :show, status: :created, location: @seller }
      else
        format.html { render :new }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @seller.update(seller_params)
        format.html { redirect_to @seller, notice: 'Seller was successfully updated.' }
        format.json { render :show, status: :ok, location: @seller }
      else
        format.html { render :edit }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @seller.destroy
    respond_to do |format|
      format.html { redirect_to sellers_url, notice: 'Seller was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def resend_activation
    if request.post?
      email = params[:seller][:email]
      @seller = Seller.new({ email: email })
      result = ValidatesEmailFormatOf::validate_email_format(email)
      unless result
        if Seller.find_by_email email
          SellerMailer.registration.deliver
          render :activation_resent
        else
          flash.now[:alert] = t('email_not_found')
        end
      else
        flash.now[:alert] = result.join(' ')
      end
    else
      @seller = Seller.new
    end
  end

  def login
    redirect_to seller_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seller
      # TODO id must be taken from session
      # @seller = Seller.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def seller_params
      params.require(:seller).permit(:first_name, :last_name, :street, :zip_code, :city, :email, :phone, :accept_terms)
    end
end
