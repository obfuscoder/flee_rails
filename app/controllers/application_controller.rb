class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_seller_id
    session[:seller_id]
  end

  def current_seller
    @current_seller ||= Seller.find current_seller_id if current_seller_id
  end
end
